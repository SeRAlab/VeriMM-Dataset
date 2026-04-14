`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg sel;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input A (Basic)", test_num);
            a = 5'h0A;
            b = 5'h15;
            sel = 1'b0;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input B (Basic)", test_num);
            a = 5'h0A;
            b = 5'h15;
            sel = 1'b1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Change A while sel=0", test_num);
            sel = 1'b0;
            a = 5'h1F;
            b = 5'h00;
            #2;
            a = 5'h10;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Change B while sel=1", test_num);
            sel = 1'b1;
            a = 5'h1F;
            b = 5'h00;
            #2;
            b = 5'h07;
            #1;

            check_outputs(5'h07);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Change B while sel=0 (Data Forwarding Isolation)", test_num);
            a = 5'h12;
            b = 5'h00;
            sel = 1'b0;
            #2;
            b = 5'h1F;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Change A while sel=1 (Data Forwarding Isolation)", test_num);
            a = 5'h00;
            b = 5'h0E;
            sel = 1'b1;
            #2;
            a = 5'h1F;
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum 5-bit values (5'h1F)", test_num);
            a = 5'h1F;
            b = 5'h1F;
            sel = 1'b0;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle Select Signal", test_num);
            a = 5'h05;
            b = 5'h1A;
            sel = 1'b0; #2;
            sel = 1'b1; #2;
            sel = 1'b0;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bit patterns", test_num);
            a = 5'b01010;
            b = 5'b10101;
            sel = 1'b1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
