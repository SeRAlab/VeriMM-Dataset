`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            si = 0;
            @(negedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Pattern 10110", test_num);
            reset_dut();



            si = 1; @(posedge clk);
            si = 0; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 0; @(posedge clk);



            si = 0;


            #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(0);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Pattern 11111", test_num);
            reset_dut();


            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);
            si = 1; @(posedge clk);

            si = 0;
            #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern 01010", test_num);
            reset_dut();


            si = 0; @(posedge clk);
            si = 1; @(posedge clk);
            si = 0; @(posedge clk);
            si = 1; @(posedge clk);
            si = 0; @(posedge clk);

            si = 1;
            #1; #1;
 check_outputs(0);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(0);
            @(posedge clk); #1; #1;
 check_outputs(1);
            @(posedge clk); #1; #1;
 check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();


            si = 1; @(posedge clk);
            si = 1; @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            si = 0;
            repeat(5) @(posedge clk);


            #1; #1;
 check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("siso_shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
        $dumpvars(0,clk, rst, si, so);
    end

endmodule
