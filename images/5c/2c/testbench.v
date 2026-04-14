`timescale 1ns/1ps

module adder_pipe_32bit_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] add_a;
    reg [31:0] add_b;
    reg clk;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_pipe_32bit dut (
        .add_a(add_a),
        .add_b(add_b),
        .clk(clk),
        .i_en(i_en),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            add_a = 0;
            add_b = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (100 + 200)", test_num);
            reset_dut();

            add_a = 32'd100;
            add_b = 32'd200;
            i_en = 1;
            @(posedge clk);
            i_en = 0;


            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Test (FFFFFFFF + 1)", test_num);
            reset_dut();

            add_a = 32'hFFFFFFFF;
            add_b = 32'h00000001;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            reset_dut();

            add_a = 32'h12345678;
            add_b = 32'h00000000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Values", test_num);
            reset_dut();

            add_a = 32'h70000000;
            add_b = 32'h07000000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 32'h77000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal Logic (i_en=0)", test_num);
            reset_dut();

            add_a = 32'hAAAA_AAAA;
            add_b = 32'h5555_5555;
            i_en = 0;


            repeat(10) @(posedge clk);

            #1;

            if (o_en === 1'b0) begin
                $display("PASS: o_en stayed low as expected.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: o_en went high despite i_en=0.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_pipe_32bit Testbench");
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
        input expected_o_en;
        input [31:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,add_a, add_b, clk, i_en, rst_n, o_en, result);
    end

endmodule
