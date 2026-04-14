`timescale 1ns/1ps

module register_comparator_tb;

    // Testbench signals (sequential circuit)
    reg check_en;
    reg clk;
    reg [7:0] rfr;
    reg rst;
    reg [7:0] sig;
    reg verbose_en;
    wire check;
    wire verbose;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_comparator dut (
        .check_en(check_en),
        .clk(clk),
        .rfr(rfr),
        .rst(rst),
        .sig(sig),
        .verbose_en(verbose_en),
        .check(check),
        .verbose(verbose)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            check_en = 0;
            verbose_en = 0;
            sig = 8'h00;
            rfr = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Equal signals (sig == rfr), check_en = 1", test_num);
            reset_dut();
            sig = 8'hA5;
            rfr = 8'hA5;
            check_en = 1;
            verbose_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Unequal signals (sig != rfr), check_en = 1", test_num);
            reset_dut();
            sig = 8'hA5;
            rfr = 8'h5A;
            check_en = 1;
            verbose_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Unequal signals, check_en = 0", test_num);
            reset_dut();
            sig = 8'hFF;
            rfr = 8'h00;
            check_en = 0;
            verbose_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Verbose enabled, signals match", test_num);
            reset_dut();
            sig = 8'h12;
            rfr = 8'h12;
            check_en = 1;
            verbose_en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Verbose enabled, signals mismatch", test_num);
            reset_dut();
            sig = 8'hDE;
            rfr = 8'hAD;
            check_en = 1;
            verbose_en = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Check state during synchronous reset", test_num);

            sig = 8'hFF;
            rfr = 8'hEE;
            check_en = 1;
            verbose_en = 0;
            rst = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_comparator Testbench");
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
        input expected_check;
        input expected_verbose;
        begin
            if (expected_check === (expected_check ^ check ^ expected_check) &&
                expected_verbose === (expected_verbose ^ verbose ^ expected_verbose)) begin
                $display("PASS");
                $display("  Outputs: check=%b, verbose=%b",
                         check, verbose);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: check=%b, verbose=%b",
                         expected_check, expected_verbose);
                $display("  Got:      check=%b, verbose=%b",
                         check, verbose);
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
        $dumpvars(0,check_en, clk, rfr, rst, sig, verbose_en, check, verbose);
    end

endmodule
