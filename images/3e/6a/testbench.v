`timescale 1ns/1ps

module Ch_function_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] x;
    reg [31:0] y;
    reg [31:0] z;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Ch_function dut (
        .clk(clk),
        .x(x),
        .y(y),
        .z(z),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            x <= 32'h0;
            y <= 32'h0;
            z <= 32'h0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'h00000000;
            y <= 32'h00000000;
            z <= 32'h00000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All Zeros", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'hFFFFFFFF;
            y <= 32'hABCD1234;
            z <= 32'h00000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: x=All Ones (Choose y)", test_num);
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'h00000000;
            y <= 32'h00000000;
            z <= 32'h55AA55AA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: x=All Zeros (Choose z)", test_num);
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'hAAAAAAAA;
            y <= 32'hFFFFFFFF;
            z <= 32'h00000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Alternating Bit Selection", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'hF0F0F0F0;
            y <= 32'hCCCC3333;
            z <= 32'hAA55AA55;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Mixed Complex Pattern", test_num);
            #1;

            check_outputs(32'hCAC53A35);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'h12345678;
            y <= 32'hDEADBEEF;
            z <= 32'hDEADBEEF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: y equals z Identity", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'hFFFFFFFF;
            y <= 32'h55555555;
            z <= 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Complementary Pattern (x=1s)", test_num);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            x <= 32'h00000000;
            y <= 32'h55555555;
            z <= 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Complementary Pattern (x=0s)", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Ch_function Testbench");
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, x, y, z, out);
    end

endmodule
