`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 8'h0;
            B = 8'h0;
            @(posedge clk);
            #1;
            rst = 0;

            if (Z !== 16'h0) begin
                $display("Reset Fail: Z should be 0, got %h", Z);
            end
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 5 * 4", test_num);
            reset_dut();
            A = 8'd5;
            B = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 255 * 0", test_num);
            reset_dut();
            A = 8'd255;
            B = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 255 * 1", test_num);
            reset_dut();
            A = 8'd255;
            B = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 255 * 255", test_num);
            reset_dut();
            A = 8'd255;
            B = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 16 * 16", test_num);
            reset_dut();
            A = 8'd16;
            B = 8'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 13 * 17", test_num);
            reset_dut();
            A = 8'd13;
            B = 8'd17;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd221);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 123 * 45", test_num);
            reset_dut();
            A = 8'd123;
            B = 8'd45;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5535);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [15:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, clk, rst, Z);
    end

endmodule
