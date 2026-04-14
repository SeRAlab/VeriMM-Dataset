`timescale 1ns/1ps

module mux_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [1:0] sel;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_8bit dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A (sel=00)", test_num);
            A = 8'hAA;
            B = 8'h55;
            C = 8'hF0;
            D = 8'h0F;
            sel = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B (sel=01)", test_num);
            A = 8'h12;
            B = 8'h34;
            C = 8'h56;
            D = 8'h78;
            sel = 2'b01;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select C (sel=10)", test_num);
            A = 8'hDE;
            B = 8'hAD;
            C = 8'hBE;
            D = 8'hEF;
            sel = 2'b10;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D (sel=11)", test_num);
            A = 8'h00;
            B = 8'hFF;
            C = 8'h5A;
            D = 8'hA5;
            sel = 2'b11;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs identical, sel=01", test_num);
            A = 8'h42;
            B = 8'h42;
            C = 8'h42;
            D = 8'h42;
            sel = 2'b01;
            #1;

            check_outputs(8'h42);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values 0x00, sel=10", test_num);
            A = 8'hFF;
            B = 8'hFF;
            C = 8'h00;
            D = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values 0xFF, sel=11", test_num);
            A = 8'h00;
            B = 8'h00;
            C = 8'h00;
            D = 8'hFF;
            sel = 2'b11;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rapid select switch to A", test_num);
            A = 8'h11;
            B = 8'h22;
            C = 8'h33;
            D = 8'h44;
            sel = 2'b11; #5;
            sel = 2'b00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_8bit Testbench");
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
        input [7:0] expected_Y;
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
