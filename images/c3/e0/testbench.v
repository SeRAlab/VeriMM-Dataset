`timescale 1ns/1ps

module concat_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg ctrl;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat_8bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ctrl(ctrl),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            a = 8'h0;
            b = 8'h0;
            ctrl = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ctrl=1, a=0xAA, b=0xBB", test_num);
            reset_dut();
            a = 8'hAA;
            b = 8'hBB;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAABB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ctrl=0, a=0xAA, b=0xBB", test_num);
            reset_dut();
            a = 8'hAA;
            b = 8'hBB;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hBBAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ctrl=1, a=0x12, b=0x34", test_num);
            reset_dut();
            a = 8'h12;
            b = 8'h34;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ctrl=0, a=0x12, b=0x34", test_num);
            reset_dut();
            a = 8'h12;
            b = 8'h34;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3412);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values ctrl=1", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'h00;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values ctrl=0", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'h00;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical inputs", test_num);
            reset_dut();
            a = 8'h55;
            b = 8'h55;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat_8bit Testbench");
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
        input [15:0] expected_out;
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
        $dumpvars(0,a, b, clk, ctrl, reset, out);
    end

endmodule
