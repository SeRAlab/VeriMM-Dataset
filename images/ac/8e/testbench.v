`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg led_clk;
    reg ledaddrcs;
    reg ledrst;
    reg [15:0] ledwdata;
    reg ledwrite;
    wire [15:0] ledout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .led_clk(led_clk),
        .ledaddrcs(ledaddrcs),
        .ledrst(ledrst),
        .ledwdata(ledwdata),
        .ledwrite(ledwrite),
        .ledout(ledout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Basic Write Operation", test_num);
            reset_dut();


            ledaddrcs = 1;
            ledwrite = 1;
            ledwdata = 16'hAAAA;
            @(posedge led_clk);
            #1 ledwrite = 0;
            ledaddrcs = 0;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Write with CS Low", test_num);
            reset_dut();


            ledaddrcs = 0;
            ledwrite = 1;
            ledwdata = 16'h5555;
            @(posedge led_clk);
            #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Write with Write Enable Low", test_num);
            reset_dut();


            ledaddrcs = 1;
            ledwrite = 0;
            ledwdata = 16'h1234;
            @(posedge led_clk);
            #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Sequential Writes", test_num);
            reset_dut();


            ledaddrcs = 1;
            ledwrite = 1;
            ledwdata = 16'h1111;
            @(posedge led_clk);


            #1 ledwdata = 16'h2222;
            @(posedge led_clk);
            #1 ledwrite = 0;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running testcase%03d: Reset Override During Write", test_num);
            reset_dut();


            ledaddrcs = 1;
            ledwrite = 1;
            ledwdata = 16'hFFFF;
            @(posedge led_clk);


            #1 ledrst = 1;
            @(posedge led_clk);
            #1 ledrst = 0;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_ledout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ledout === (expected_ledout ^ ledout ^ expected_ledout)) begin
                $display("PASS");
                $display("  Outputs: ledout=%h",
                         ledout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ledout=%h",
                         expected_ledout);
                $display("  Got:      ledout=%h",
                         ledout);
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

endmodule
