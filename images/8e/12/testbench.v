`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ionewire;
    reg [7:0] isizedwire;
    wire oonewire;
    wire [7:0] osizedreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ionewire(ionewire),
        .isizedwire(isizedwire),
        .oonewire(oonewire),
        .osizedreg(osizedreg)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);

        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;


        isizedwire = 8'd5;
        ionewire = 1'b1;
        @(posedge clk); #1;


        ionewire = 1'b0;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;

        isizedwire = 8'd1;
        ionewire = 1'b1;
        @(posedge clk); #1;

        ionewire = 1'b0;
        @(posedge clk);

        #1;


        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;

        isizedwire = 8'd10;
        ionewire = 1'b1;
        @(posedge clk); #1;

        ionewire = 1'b0;
        repeat(4) @(posedge clk);

        #1;


        check_outputs(1'b1, 8'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;

        isizedwire = 8'd0;
        ionewire = 1'b1;
        @(posedge clk); #1;

        #1;


        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;

        isizedwire = 8'd20;
        ionewire = 1'b1;
        @(posedge clk); #1;

        ionewire = 1'b0;
        repeat(5) @(posedge clk); #1;


        isizedwire = 8'd3;
        ionewire = 1'b1;
        @(posedge clk); #1;

        ionewire = 1'b0;
        repeat(3) @(posedge clk);

        #1;


        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        reset = 1; ionewire = 0; isizedwire = 0;
        @(posedge clk); #1; reset = 0;

        isizedwire = 8'd255;
        ionewire = 1'b1;
        @(posedge clk); #1;

        ionewire = 1'b0;
        repeat(128) @(posedge clk);



        #1;




        check_outputs(1'b1, 8'd126);
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
        input expected_oonewire;
        input [7:0] expected_osizedreg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oonewire === (expected_oonewire ^ oonewire ^ expected_oonewire) &&
                expected_osizedreg === (expected_osizedreg ^ osizedreg ^ expected_osizedreg)) begin
                $display("PASS");
                $display("  Outputs: oonewire=%b, osizedreg=%h",
                         oonewire, osizedreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oonewire=%b, osizedreg=%h",
                         expected_oonewire, expected_osizedreg);
                $display("  Got:      oonewire=%b, osizedreg=%h",
                         oonewire, osizedreg);
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
