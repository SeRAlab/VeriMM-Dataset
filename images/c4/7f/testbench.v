`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg ctrl;
    reg rst;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ctrl(ctrl),
        .rst(rst),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            ctrl = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (ctrl=1)", test_num);
            reset_dut();
            a = 8'h05;
            b = 8'h0A;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Value (ctrl=0)", test_num);
            reset_dut();


            a = 8'h10;
            b = 8'h20;
            ctrl = 1;
            @(posedge clk);
            #1;


            ctrl = 0;
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0030);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values Addition", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority", test_num);
            reset_dut();

            a = 8'h12;
            b = 8'h34;
            ctrl = 1;
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            reset_dut();
            a = 8'h00;
            b = 8'h00;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Operations", test_num);
            reset_dut();


            a = 8'd50; b = 8'd50; ctrl = 1;
            @(posedge clk);
            #1;


            a = 8'd10; b = 8'd10; ctrl = 0;
            @(posedge clk);
            #1;


            a = 8'd5; b = 8'd5; ctrl = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, ctrl, rst, sum);
    end

endmodule
