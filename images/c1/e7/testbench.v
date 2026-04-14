`timescale 1ns/1ps

module adder_4bit_cin_cout_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg reset;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_4bit_cin_cout dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .reset(reset),
        .cout(cout),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            cin = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Check", test_num);

            a = 4'hF;
            b = 4'hF;
            cin = 1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 3)", test_num);
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-in (10 + 2 + 1)", test_num);
            reset_dut();
            a = 4'd10;
            b = 4'd2;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-out Check (8 + 8)", test_num);
            reset_dut();
            a = 4'd8;
            b = 4'd8;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (15 + 15 + 1)", test_num);
            reset_dut();
            a = 4'hF;
            b = 4'hF;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow to zero (15 + 0 + 1)", test_num);
            reset_dut();
            a = 4'hF;
            b = 4'h0;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (1010 + 0101)", test_num);
            reset_dut();
            a = 4'b1010;
            b = 4'b0101;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit_cin_cout Testbench");
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
        $dumpvars(0,a, b, cin, clk, reset, cout, sum);
    end

endmodule
