`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg sel;
    wire hazard;
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
        .hazard(hazard),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select A with distinct values", test_num);
            a = 5'b01010;
            b = 5'b10101;
            sel = 1'b0;

            #1;


            check_outputs(1'b0, 5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select B with distinct values", test_num);
            a = 5'b01010;
            b = 5'b10101;
            sel = 1'b1;

            #1;


            check_outputs(1'b0, 5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition check - Both inputs high", test_num);

            a = 5'b11111;
            b = 5'b11111;
            sel = 1'b0;
            #5;
            sel = 1'b1;



            #1;




            check_outputs(1'b0, 5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros input", test_num);
            a = 5'b00000;
            b = 5'b00000;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selection change B to A", test_num);
            a = 5'h1E;
            b = 5'h0F;
            sel = 1'b1;
            #5;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 5'h1E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A change while B selected", test_num);
            a = 5'h00;
            b = 5'h1F;
            sel = 1'b1;
            #5;
            a = 5'h11;

            #1;


            check_outputs(1'b0, 5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input B change while A selected", test_num);
            a = 5'h12;
            b = 5'h00;
            sel = 1'b0;
            #5;
            b = 5'h1F;

            #1;


            check_outputs(1'b0, 5'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value check", test_num);
            a = 5'h1F;
            b = 5'h1F;
            sel = 1'b1;
            #1;

            check_outputs(1'b0, 5'h1F);
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
        input expected_hazard;
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard === (expected_hazard ^ hazard ^ expected_hazard) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: hazard=%b, y=%h",
                         hazard, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard=%b, y=%h",
                         expected_hazard, expected_y);
                $display("  Got:      hazard=%b, y=%h",
                         hazard, y);
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
