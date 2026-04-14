`timescale 1ns/1ps

module shiftreg4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shiftreg4bit dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift in 1111", test_num);
            reset_dut();
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift in sequence 1-0-1-0", test_num);
            reset_dut();
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            #1 #1;
 check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift in sequence 1-0-1-1", test_num);
            reset_dut();
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift 5 bits (1-1-0-0-1)", test_num);
            reset_dut();
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            din = 0; @(posedge clk);
            din = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shiftreg4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
