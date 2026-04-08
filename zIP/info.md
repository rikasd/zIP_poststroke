# Modified intersection-point-height calculation

## Data processing

In previous work [1,2], the principal component analysis was used 
to extract the slope of the principal eigenvector of the covariance matrix of
bandpass-filtered center-of-mass displacement and foot-ground-interaction-force orientation data
to obtain the intersection-point-height measure at each frequency, $$z_{IP}(f)$$.
However, principal component analysis is sentivite to units [3].
Therefore, Boehm et al. 2019 standardized the bandpass-filtered data by dividing by their respective
standard deviation before computing the principal-component slope of the covariance, and then re-normalizing
by the ratio of standard deviations [4]. Since the 2-by-2 covariance matrix of standardized bandpass-filtered data
will have a principal component with slope of 1, $$z_{IP}(f)$$ would be given by the ratio of standard deviations
of bandpass-filtered center-of-mass displacement over foot-force orientation.

As an alternative approach, in this work we defined the intersection-point-height measure at a given frequency
by the ratio of the covariance between bandpass-filtered center-of-mass displacement and
foot-force orientation, over the variance of bandpass-filtered foot-force orientation:

$$z_{IP}(f) = \frac{cov\left(\theta_F(t;f,B_e),x_\text{CoP}(t;f,B_e)\right)}{var\left(\theta_F(t;f,B_e)\right)}$$

where $\theta_F(t;f,B_e)$ and $x_\text{CoP}(t;f,B_e)$ denote the foot-force orientation and center-of-mass displacement
bandpass-filtered at center frequency $f$ with bandwidth $B_e$.
This is the approach that we used to process the data via the getZIPfromData.m code in this work.

## Modeling

In the limit that the bandwidth is taken to be infinitesimally narrow ($B_e\rightarrow 0$),
the covariance between bandpass-filtered $\theta_F$ and $x_{CoP}$ is equivalent to the real part of
the one-sided cross-spectral density between $\theta_F$ and $x_{CoP}$ at the center frequency $f$ [5]:

$$\lim\limits_{B_e\rightarrow0}\text{cov}\left(\theta_F(t;f,B_e),x_\text{CoP}(t;f,B_e)\right) = \Re\left(G_{\theta_Fx_\text{CoP}}(f)\right)$$

Similarly, the variance of bandpass-filtered $\theta_F$ when $B_e\rightarrow 0$ is equivalent to the
one-sided auto-spectral density:

$$\lim\limits_{B_e\rightarrow0}\text{var}\left(\theta_F(t;f,B_e)\right) = G_{\theta_F\theta_F}(f)$$

Thus, $$z_{IP}(f)$$ can also be computed from the spectral densities as:

$$z_{IP}(f) = \frac{\Re\left(G_{\theta_Fx_\text{CoP}}(f)\right)}{G_{\theta_F\theta_F}(f)}$$

This is useful because the spectral densities can be computed from the frequency-response-function of
a linearized human-standing model [6]:

$$\mathbf{y}(f) = \mathbf{H}(f)\mathbf{w}(f)$$

where $\mathbf{y} = [\theta_F, x_\text{CoP}]^T$ is the output vector of foot-ground force measurements
($\cdot^T$ is the matrix transpose operator), $\mathbf{w}$ is the input vector of biological noise processes,
and $\mathbf{H}(f)$ is the frequency response function relating the two.
The output spectral density matrix $\mathbf{G_{yy}}(f)$ can be estimated from the frequency response function $\mathbf{H}(f)$
and the input spectral density matrix $\mathbf{G_{ww}}(f)$ [5]:

$$\mathbf{G_{yy}}(f) = \mathbf{H}(-f)\mathbf{G_{ww}}(f)\mathbf{H}(f)^T$$

and the output spectral density is composed of the one-sided auto- and cross-spectral densities:

$$\mathbf{G_{yy}}(f) =
\begin{bmatrix}
    \strut G_{\theta_F\theta_F}(f) & G_{\theta_Fx_\text{CoP}}(f)\\
    \strut G_{x_\text{CoP}\theta_F}(f) & G_{x_\text{CoP}x_\text{CoP}}(f)
\end{bmatrix}$$

Thus, the quantities $G_{\theta_Fx_\text{CoP}}(f)$ and $G_{\theta_F\theta_F}(f)$ can be derived 
from the linearized model to compute the $z_{IP}(f)$ as:

$$z_{IP}(f) = \frac{\Re\left(G_{\theta_Fx_\text{CoP}}(f)\right)}{G_{\theta_F\theta_F}(f)}$$

This method is used to obtain the intersection-point-height measure from a given model in the 
predictZIPfromModel.m code in this work.

Further details and derivation of this method can be found in the PDF document under the 
[docs](https://github.com/rikasd/zIP_poststroke/new/main/docs/) directory.

## References

[1] Shiozawa K, Sugimoto-Dimitrova R, Gruben KG, Hogan N. (2024a).
Human foot force suggests different balance control between younger and older adults.
J Neurophysiol 132: 1457–1469. doi: 10.1152/jn.00161.2024.
  
[2] Shiozawa K, Russo M, Lee J, Hogan N, Sternad D. (2024b).
Human foot force informs balance control strategies when standing on a narrow beam.
J Neurophysiol 132: 1302–1314. doi: 10.1152/jn.00089.2024.

[3] Sternad D, Park S-W, Muller H, Hogan N. (2010). Coordinate dependence of variability analysis.
PLoS One 6: 1–10. doi: 10.1371/journal.pcbi.1000751.

[4] Boehm WL, Nichols KM, Gruben KG. (2019).
Frequency-dependent contributions of sagittal-plane foot force to upright human standing.
J Biomech 83: 305–309. doi:10.1016/j.jbiomech.2018.11.039.

[5] Bendat JS, Piersol AG. (2010). Random Data: Analysis and Measurement Procedures. Hoboken, NJ: Wiley.

[6] Sugimoto-Dimitrova R, Shiozawa K, Gruben KG, Hogan N. (2024). 
Frequency-domain patterns in foot-force line-of-action: an emergent property of standing balance control.
J Neurophysiol 132: 1445–1456. doi: 10.1152/jn.00084.2024.
  



