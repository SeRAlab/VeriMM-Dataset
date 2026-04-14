`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg Clk;
    wire [3:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .B(B),
        .Clk(Clk),
        .G(G)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            B = 4'b0000;
            @(posedge Clk);
            #1;
            $display("DUT Reset: B=%b, G=%b", B, G);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Binary 0000 -> Gray 0000", test_num);
            B = 4'b0000;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Binary 0001 -> Gray 0001", test_num);
            B = 4'b0001;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Binary 0011 -> Gray 0010", test_num);
            B = 4'b0011;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Binary 0100 -> Gray 0110", test_num);
            B = 4'b0100;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Binary 0111 -> Gray 0100", test_num);
            B = 4'b0111;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Binary 1000 -> Gray 1100", test_num);
            B = 4'b1000;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Binary 1010 -> Gray 1111", test_num);
            B = 4'b1010;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Binary 1100 -> Gray 1010", test_num);
            B = 4'b1100;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: Binary 1111 -> Gray 1000", test_num);
            B = 4'b1111;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_G;
        begin
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%h",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%h",
                         expected_G);
                $display("  Got:      G=%h",
                         G);
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
        $dumpvars(0,B, Clk, G);
    end

endmodule
