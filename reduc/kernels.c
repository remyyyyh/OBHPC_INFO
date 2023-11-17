#include <stdio.h>
//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 reduc_base(f64 *restrict a, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++){
    d += a[i];
  }
  return d;
}

f64 reduc_unroll4(f64 *restrict a, u64 n)
{
  #define UNROLL4 4
  f64 d = 0.0;
  
  for (u64 i = 0; i < (n - (n % UNROLL4)); i += UNROLL4)
  {
    d += a[i] + a[i + 1] + a[i + 2] + a[i + 3];
  }

  // Gérer les éléments restants
  for (u64 i = n - (n % UNROLL4); i < n; i++)
  {
    d += a[i];
  }
  
  return d;
}


f64 reduc_unroll8(f64 *restrict a, u64 n)
{
  #define UNROLL8 8
  f64 d = 0.0;
  for (u64 i = 0; i < (n - (n % UNROLL8)); i += UNROLL8)
  {
    d += a[i] + a[i + 1] + a[i + 2] + a[i + 3] + a[i + 4] + a[i + 5] + a[i + 6] + a[i + 7];
  }

  // Gérer les éléments restants
  for (u64 i = n - (n % UNROLL8); i < n; i++)
  {
    d += a[i];
  }
  return d;
}


f64 reduc_cblas(f64 *restrict a, u64 n)
{
  return cblas_dasum(n, a, 1);;
}
