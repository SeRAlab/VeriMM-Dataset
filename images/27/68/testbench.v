`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg clk;
    reg reset;
    wire [5:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd10;
            B = 5'd5;

            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d", test_num, A, B);
            #1;

            check_outputs(6'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd31;
            B = 5'd31;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d (Maximum values)", test_num, A, B);
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd16;
            B = 5'd16;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d (Power of 2 check)", test_num, A, B);
            #1;

            check_outputs(6'd32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd0;
            B = 5'd0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d (Zero check)", test_num, A, B);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd31;
            B = 5'd0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d (Boundary check)", test_num, A, B);
            #1;

            check_outputs(6'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 5'd1;
            B = 5'd1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Input %d + %d", test_num, A, B);
            #1;

            check_outputs(6'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        input [5:0] expected_S;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
        $dumpvars(0,A, B, clk, reset, S);
    end

endmodule
