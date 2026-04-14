`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
            $display("\nTest %0d: All inputs zero", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'hA0; C = 8'h12; D = 8'h55;
            $display("\nTest %0d: A is maximum (0xFF)", test_num);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'h22; B = 8'hC8; C = 8'hB0; D = 8'h01;
            $display("\nTest %0d: B is maximum (0xC8)", test_num);
            #1;

            check_outputs(16'h00C8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'h0F; B = 8'h1F; C = 8'hEF; D = 8'h2F;
            $display("\nTest %0d: C is maximum (0xEF)", test_num);
            #1;

            check_outputs(16'h00EF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'h01; B = 8'h02; C = 8'h03; D = 8'h04;
            $display("\nTest %0d: D is maximum (0x04)", test_num);
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'h77; B = 8'h77; C = 8'h77; D = 8'h77;
            $display("\nTest %0d: All inputs equal (0x77)", test_num);
            #1;

            check_outputs(16'h0077);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h00; C = 8'hAA; D = 8'h11;
            $display("\nTest %0d: Multiple inputs maximum (A and C = 0xAA)", test_num);
            #1;

            check_outputs(16'h00AA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'd255; B = 8'd254; C = 8'd253; D = 8'd252;
            $display("\nTest %0d: Edge case max value (255)", test_num);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h01; C = 8'h00; D = 8'h00;
            $display("\nTest %0d: Smallest non-zero max (0x01)", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'h80; B = 8'h40; C = 8'h20; D = 8'h10;
            $display("\nTest %0d: Descending order", test_num);
            #1;

            check_outputs(16'h0080);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
            #1; // Small delay for combinational logic to settle
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

endmodule
