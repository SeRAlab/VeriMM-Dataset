`timescale 1ns/1ps

module modulo_50_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    modulo_50_counter dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
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
            $display("Test %0d: Verifying reset state...", test_num);
            reset_dut();




            #1;





            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Incrementing to 10 cycles...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Checking boundary value 49...", test_num);
            reset_dut();
            repeat(49) @(posedge clk);
            #1 #1;
 check_outputs(6'd49);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Checking modulo rollover (50 cycles)...", test_num);
            reset_dut();
            repeat(50) @(posedge clk);
            #1 #1;
 check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Checking multiple rollovers (125 cycles)...", test_num);
            reset_dut();
            repeat(125) @(posedge clk);
            #1 #1;
 check_outputs(6'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Checking rollover + 1 cycle (51 cycles)...", test_num);
            reset_dut();
            repeat(51) @(posedge clk);
            #1 #1;
 check_outputs(6'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("modulo_50_counter Testbench");
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
