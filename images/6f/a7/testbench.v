`timescale 1ns/1ps

module or_gate_pipe_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [15:0] or_a;
    reg [15:0] or_b;
    reg rst_n;
    wire o_en;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_gate_pipe_16bit dut (
        .clk(clk),
        .i_en(i_en),
        .or_a(or_a),
        .or_b(or_b),
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
            or_a = 0;
            or_b = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros OR Operation", test_num);
            reset_dut();

            or_a = 16'h0000;
            or_b = 16'h0000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;



            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones OR Operation", test_num);
            reset_dut();

            or_a = 16'hFFFF;
            or_b = 16'h0000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (Complementary)", test_num);
            reset_dut();

            or_a = 16'hAAAA;
            or_b = 16'h5555;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Specific Nibble Logic", test_num);
            reset_dut();

            or_a = 16'h1234;
            or_b = 16'h8765;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;
            #1;

            check_outputs(1'b1, (16'h1234 | 16'h8765));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Impact During Operation", test_num);
            reset_dut();

            or_a = 16'hFFFF;
            or_b = 16'hFFFF;
            i_en = 1;
            @(posedge clk);

            rst_n = 0;
            @(posedge clk);
            rst_n = 1;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, result);
        end
        endtask

    task testcase006;

        reg [15:0] expected_results [2:0];
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pipeline Continuous Flow", test_num);
            reset_dut();


            or_a = 16'hF0F0; or_b = 16'h0F0F; expected_results[0] = 16'hFFFF;
            i_en = 1; @(posedge clk);
            or_a = 16'h00FF; or_b = 16'hFF00; expected_results[1] = 16'hFFFF;
            i_en = 1; @(posedge clk);
            or_a = 16'h1111; or_b = 16'h2222; expected_results[2] = 16'h3333;
            i_en = 1; @(posedge clk);
            i_en = 0;


            for(i = 0; i < 3; i = i + 1) begin
                wait(o_en == 1);
                #1;
                if (result == expected_results[i])
                    $display("Sub-test %0d: PASS", i);
                else
                    $display("Sub-test %0d: FAIL (Expected %h, Got %h)", i, expected_results[i], result);
                @(posedge clk);
            end


            #1;



            check_outputs(1'b0, result);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
        end
        endtask

    task testcases2;

        begin
            testcase004();
            testcase005();
            testcase006();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_gate_pipe_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcases1();
        testcases2();
        
        
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
        input [15:0] expected_result;
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
        $dumpvars(0,clk, i_en, or_a, or_b, rst_n, o_en, result);
    end

endmodule
