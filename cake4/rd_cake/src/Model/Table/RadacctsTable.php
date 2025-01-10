<?php
namespace App\Model\Table;
use Cake\ORM\Table;

class RadacctsTable extends Table {

    public function initialize(array $config):void {
        $this->setTable('radacct');        
      $this->hasMany('UserStats',['dependent' => true]);       
       $this->belongsTo('PermanentUsers')
            ->setForeignKey('username')
            ->setBindingKey('username')
            ->setJoinType('INNER');
    }       
}
