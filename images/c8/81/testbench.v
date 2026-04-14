`timescale 1ns/1ps

module And_Module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    And_Module dut (
        .a(a),
        .b(b),
        .out(out),
        .out_valid(out_valid)
    );

        task reset_dut;

        begin
            a <= 8'h0;
            b <= 8'h0;
            rst_n <= 0;
            repeat(2) @(posedge clk);
            rst_n <= 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=00, b=FF", test_num);
            reset_dut();
            a <= 8'h00;
            b <= 8'hFF;

            wait(out_valid == 1);
            #1;

            check_outputs(8'h00, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=FF, b=FF", test_num);
            reset_dut();
            a <= 8'hFF;
            b <= 8'hFF;
            wait(out_valid == 1);
            #1;

            check_outputs(8'hFF, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=AA, b=55", test_num);
            reset_dut();
            a <= 8'hAA;
            b <= 8'h55;
            wait(out_valid == 1);
            #1;

            check_outputs(8'h00, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=F0, b=CC", test_num);
            reset_dut();
            a <= 8'hF0;
            b <= 8'hCC;
            wait(out_valid == 1);
            #1;

            check_outputs(8'hC0, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=12, b=34", test_num);
            reset_dut();
            a <= 8'h12;
            b <= 8'h34;
            wait(out_valid == 1);
            #1;

            check_outputs(8'h10, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=80, b=80", test_num);
            reset_dut();
            a <= 8'h80;
            b <= 8'h80;
            wait(out_valid == 1);
            #1;

            check_outputs(8'h80, 1'b1);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("And_Module Testbench");
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
        input [7:0] expected_out;
        input expected_out_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_valid=%b",
                         out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_valid=%b",
                         expected_out, expected_out_valid);
                $display("  Got:      out=%h, out_valid=%b",
                         out, out_valid);
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
        $dumpvars(0,a, b, out, out_valid);
    end

endmodule
