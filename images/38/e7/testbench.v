`timescale 1ns/1ps

module power_gated_mux_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg power_gate;
    reg sel;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gated_mux dut (
        .A(A),
        .B(B),
        .power_gate(power_gate),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Gating Active (PG=0), sel=0", test_num);
            power_gate = 1'b0;
            sel = 1'b0;
            A = 5'h1F;
            B = 5'h0A;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Gating Active (PG=0), sel=1", test_num);
            power_gate = 1'b0;
            sel = 1'b1;
            A = 5'h1F;
            B = 5'h0A;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Active (PG=1), select A", test_num);
            power_gate = 1'b1;
            sel = 1'b0;
            A = 5'h12;
            B = 5'h05;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Active (PG=1), select B", test_num);
            power_gate = 1'b1;
            sel = 1'b1;
            A = 5'h12;
            B = 5'h05;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Active (PG=1), Boundary All High (A)", test_num);
            power_gate = 1'b1;
            sel = 1'b0;
            A = 5'h1F;
            B = 5'h00;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Active (PG=1), Boundary All High (B)", test_num);
            power_gate = 1'b1;
            sel = 1'b1;
            A = 5'h00;
            B = 5'h1F;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Active (PG=1), Boundary All Low", test_num);
            power_gate = 1'b1;
            sel = 1'b0;
            A = 5'h00;
            B = 5'h1F;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Power Gating Toggle", test_num);

            power_gate = 1'b1;
            sel = 1'b1;
            A = 5'h1A;
            B = 5'h0B;
            #1;

            power_gate = 1'b0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gated_mux Testbench");
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
        input [4:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
