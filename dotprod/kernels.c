
//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"
#include <omp.h>

//Baseline - naive implementation
f64 dotprod_base(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i] * b[i];

  return d;
}


void dotprod_cblas(f64 *restrict a, f64 *restrict  b, u64 n){

  cblas_ddot(n,a,1,b,1);
}


f64 dot_product_unroll4(f64 *restrict a, f64 *restrict b, u64 n)
{
  #define UNROLL4 4
  f64 d = 0.0;

  for (u64 i = 0; i < (n - (n & (UNROLL4 - 1))); i += UNROLL4)
  {
    d += a[i] * b[i] + a[i + 1] * b[i + 1] + a[i + 2] * b[i + 2] + a[i + 3] * b[i + 3];
  }

  // Gérer les éléments restants
  for (u64 i = (n - (n & (UNROLL4 - 1))); i < n; i++)
  {
    d += a[i] * b[i];
  }

  return d;
}


f64 dot_product_unroll8(f64 *restrict a, f64 *restrict b, u64 n)
{
  #define UNROLL8 8
  f64 d = 0.0;

  for (u64 i = 0; i < (n - (n & (UNROLL8 - 1))); i += UNROLL8)
  {
    d += a[i] * b[i] + a[i + 1] * b[i + 1] + a[i + 2] * b[i + 2] + a[i + 3] * b[i + 3] +
         a[i + 4] * b[i + 4] + a[i + 5] * b[i + 5] + a[i + 6] * b[i + 6] + a[i + 7] * b[i + 7];
  }

  // Gérer les éléments restants
  for (u64 i = (n - (n & (UNROLL8 - 1))); i < n; i++)
  {
    d += a[i] * b[i];
  }

  return d;
}

f64 dot_product_parallel(f64 *restrict a, f64 *restrict b, u64 n) 
{
    f64 d = 0.0;
    
    #pragma omp parallel for reduction(+:d)
    for (u64 i = 0; i < n; ++i) {
        d += a[i] * b[i];
    }

    return d;
}
