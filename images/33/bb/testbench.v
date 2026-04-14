`timescale 1ns/1ps

module mux32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [1:0] sel;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32bit dut (
        .A(A),
        .B(B),
        .C(C),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A (sel = 00)", test_num);
            A = 32'h12345678;
            B = 32'hFFFFFFFF;
            C = 32'h00000000;
            sel = 2'b00;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B (sel = 01)", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            C = 32'h00000000;
            sel = 2'b01;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C (sel = 10)", test_num);
            A = 32'hDEADBEEF;
            B = 32'hCAFEBABE;
            C = 32'h13572468;
            sel = 2'b10;
            #1;

            check_outputs(32'h13572468);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Zero Output (sel = 11)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            C = 32'hFFFFFFFF;
            sel = 2'b11;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle check - Switch from C to B", test_num);
            A = 32'h11111111;
            B = 32'h22222222;
            C = 32'h33333333;

            sel = 2'b10;
            #5;
            sel = 2'b01;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same value", test_num);
            A = 32'hABCDE123;
            B = 32'hABCDE123;
            C = 32'hABCDE123;
            sel = 2'b00;
            #1;

            check_outputs(32'hABCDE123);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32bit Testbench");
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
        input [31:0] expected_Y;
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
