`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            $display("Resetting circuit state...");

            force dut.A = 8'h00;
            force dut.B = 8'hFF;
            force dut.H = 8'h00;
            force dut.multi = 8'h00;
            force dut.multi2 = 8'h00;
            force dut.in_f = 8'h00;
            force dut.in_g = 8'h00;
            @(posedge CLK);
            release dut.A;
            release dut.B;
            release dut.H;
            release dut.multi;
            release dut.multi2;
            release dut.in_f;
            release dut.in_g;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            force dut.A = 8'hAA;
            force dut.B = 8'h55;
            @(posedge CLK);
            #2;









            #1;










            check_outputs(8'hFF, 8'h00, 8'hAA, 1'b0, 8'hAA, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            force dut.multi  = 8'hF0;
            force dut.multi2 = 8'hCC;
            force dut.in_f   = 8'hFF;
            force dut.in_g   = 8'h00;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'hFF, 8'h00, 8'h00, 1'b0, 8'hFF, 1'b1, 1'b0, 8'h01, 8'hC0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            force dut.A = 8'h00;
            force dut.B = 8'h00;

            @(posedge CLK);
            #2;



            if (dut.D === 1'b1)
                $display("Testcase 003: Equality D detected correctly.");
            else
                $display("Testcase 003: Equality D failed.");

            #1;


            check_outputs(8'h00, 8'h00, 8'hFF, 1'b1, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,CLK);
    end

endmodule
