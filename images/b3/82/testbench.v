`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    reg clk;
    reg [2:0] in_vec;
    reg reset;
    wire cout;
    wire even_parity_out;
    wire [2:0] out_vec;
    wire [99:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .in_vec(in_vec),
        .reset(reset),
        .cout(cout),
        .even_parity_out(even_parity_out),
        .out_vec(out_vec),
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
            in_vec = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Addition (1 + 2)", test_num);
            reset_dut();
            a = 100'd1;
            b = 100'd2;
            cin = 0;
            in_vec = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 3'b000, 100'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Addition with cin (10 + 20 + 1)", test_num);
            reset_dut();
            a = 100'd10;
            b = 100'd20;
            cin = 1;
            in_vec = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 3'b001, 100'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Value Addition (Carry-out)", test_num);
            reset_dut();
            a = {100{1'b1}};
            b = 100'd1;
            cin = 1'b0;
            in_vec = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 3'b011, 100'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parity check (in_vec=111)", test_num);
            reset_dut();
            a = 100'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_A;
            b = 100'h5555_5555_5555_5555_5555_5555_5;
            cin = 1'b0;
            in_vec = 3'b111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 3'b111, {100{1'b1}});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Out_vec following In_vec", test_num);
            reset_dut();
            a = 100'd500;
            b = 100'd500;
            cin = 1'b0;
            in_vec = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 3'b101, 100'd1000);


            in_vec = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 3'b110, 100'd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset behavior", test_num);
            reset = 1;
            a = 100'hFFFF;
            b = 100'hFFFF;
            @(posedge clk);
            #2;

            if (sum === 100'd0 && out_vec === 3'b000) begin
                $display("PASS: Reset active state");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset active state (Sum: %h, Out_vec: %b)", sum, out_vec);
                fail_count = fail_count + 1;
            end
            reset = 0;
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
        input expected_cout;
        input expected_even_parity_out;
        input [2:0] expected_out_vec;
        input [99:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_even_parity_out === (expected_even_parity_out ^ even_parity_out ^ expected_even_parity_out) &&
                expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, even_parity_out=%b, out_vec=%h, sum=%h",
                         cout, even_parity_out, out_vec, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, even_parity_out=%b, out_vec=%h, sum=%h",
                         expected_cout, expected_even_parity_out, expected_out_vec, expected_sum);
                $display("  Got:      cout=%b, even_parity_out=%b, out_vec=%h, sum=%h",
                         cout, even_parity_out, out_vec, sum);
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
        $dumpvars(0,a, b, cin, clk, in_vec, reset, cout, even_parity_out, out_vec, sum);
    end

endmodule
