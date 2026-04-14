`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] datos;
    reg pl;
    reg rtcoun;
    reg ver;
    reg ver2;
    wire Z;
    wire [7:0] data;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datos(datos),
        .pl(pl),
        .rtcoun(rtcoun),
        .ver(ver),
        .ver2(ver2),
        .Z(Z),
        .data(data),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        pl = 0;
        forever #5 pl = ~pl;
    end

        task reset_dut;

        begin
            datos = 8'h00;
            rtcoun = 0;
            ver = 0;
            ver2 = 0;

            repeat(5) @(posedge pl);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Z flag and rtcoun dependency", test_num);
            reset_dut();

            rtcoun = 1;
            repeat(2) @(posedge pl);



            #1;




            check_outputs(1, 8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying 'ver' signal data capture", test_num);
            reset_dut();

            datos = 8'hAA;
            ver = 1;
            @(posedge pl);
            #1;
            ver = 0;


            #1;



            check_outputs(0, 8'h00, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verifying 'ver2' signal data capture", test_num);
            reset_dut();

            datos = 8'h55;
            ver2 = 1;
            @(posedge pl);
            #1;
            ver2 = 0;


            #1;



            check_outputs(0, 8'h00, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full data capture sequence (ver then ver2)", test_num);
            reset_dut();


            datos = 8'h0F;
            ver = 1;
            @(posedge pl);
            #1;
            ver = 0;


            datos = 8'hF0;
            ver2 = 1;
            @(posedge pl);
            #1;
            ver2 = 0;


            repeat(2) @(posedge pl);
            #1;




            #1;





            check_outputs(0, 8'hF0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interrupted capture - ver without ver2", test_num);
            reset_dut();

            datos = 8'hCC;
            ver = 1;
            @(posedge pl);
            #1;
            ver = 0;


            repeat(10) @(posedge pl);
            #1;

            #1;


            check_outputs(0, 8'h00, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive conversions test", test_num);
            reset_dut();


            datos = 8'h11; ver = 1; @(posedge pl); #1; ver = 0;
            datos = 8'h22; ver2 = 1; @(posedge pl); #1; ver2 = 0;
            repeat(2) @(posedge pl);


            datos = 8'h33; ver = 1; @(posedge pl); #1; ver = 0;
            datos = 8'h44; ver2 = 1; @(posedge pl); #1; ver2 = 0;
            repeat(2) @(posedge pl); #1;


            #1;



            check_outputs(0, 8'h44, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_Z;
        input [7:0] expected_data;
        input expected_write;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: Z=%b, data=%h, write=%b",
                         Z, data, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b, data=%h, write=%b",
                         expected_Z, expected_data, expected_write);
                $display("  Got:      Z=%b, data=%h, write=%b",
                         Z, data, write);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,datos, pl, rtcoun, ver, ver2, Z, data, write);
    end

endmodule
