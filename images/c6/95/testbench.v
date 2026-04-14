`timescale 1ns/1ps

module and8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and8 dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 8'h00;
        b <= 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        reset_dut();
        a <= 8'h00;
        b <= 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        reset_dut();
        a <= 8'hFF;
        b <= 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inverse Patterns (Zero result)", test_num);
        reset_dut();
        a <= 8'hAA;
        b <= 8'h55;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity with 0xFF", test_num);
        reset_dut();
        a <= 8'h3C;
        b <= 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity with 0x00", test_num);
        reset_dut();
        a <= 8'hFF;
        b <= 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High Nibble vs Low Nibble", test_num);
        reset_dut();
        a <= 8'hF0;
        b <= 0'h0F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Bitmask 1", test_num);
        reset_dut();
        a <= 8'h12;
        b <= 8'h34;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Bitmask 2", test_num);
        reset_dut();
        a <= 8'hCA;
        b <= 8'hFE;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hCA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,a, b, clk, out);
    end

endmodule
