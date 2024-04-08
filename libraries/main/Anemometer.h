#include "Arduino.h"
#include "DataSource.h"
#include "Pinouts.h"

class Anemometer : public DataSource
{
    Anemometer(void);

    public:
    void ISR();
    int revolution 

};