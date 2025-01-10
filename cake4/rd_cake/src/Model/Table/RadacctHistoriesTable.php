<?php
namespace App\Model\Table;
use Cake\ORM\Table;

class RadacctHistoriesTable extends Table {

    public function initialize(array $config):void {
      $this->setTable('radacct_history');
    }       
}
