`timescale 1ns/1ps

module multiplexer_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sel;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplexer_2to1 dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select A (sel=0)", test_num);
        A = 4'hA;
        B = 4'h5;
        sel = 1'b0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select B (sel=1)", test_num);
        A = 4'hA;
        B = 4'h5;
        sel = 1'b1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select A with All Zeros", test_num);
        A = 4'b0000;
        B = 4'b1111;
        sel = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select B with All Ones", test_num);
        A = 4'b0000;
        B = 4'b1111;
        sel = 1'b1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select A with Toggling Pattern", test_num);
        A = 4'b1010;
        B = 4'b0101;
        sel = 1'b0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select B with Toggling Pattern", test_num);
        A = 4'b1010;
        B = 4'b0101;
        sel = 1'b1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select A, change B (verify isolation)", test_num);
        A = 4'h7;
        sel = 1'b0;
        B = 4'h0;
        #5;
        B = 4'hF;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select B, change A (verify isolation)", test_num);
        B = 4'h3;
        sel = 1'b1;
        A = 4'h0;
        #5;
        A = 4'hE;
        #1;

        check_outputs(4'h3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplexer_2to1 Testbench");
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
        input [3:0] expected_Y;
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
