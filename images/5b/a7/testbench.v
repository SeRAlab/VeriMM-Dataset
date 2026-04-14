`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D0;
    reg [7:0] D1;
    reg [7:0] D2;
    reg [7:0] D3;
    reg [1:0] sel;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D0", test_num);
            D0 = 8'hAA;
            D1 = 8'hBB;
            D2 = 8'hCC;
            D3 = 8'hDD;
            sel = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D1", test_num);
            D0 = 8'hAA;
            D1 = 8'hBB;
            D2 = 8'hCC;
            D3 = 8'hDD;
            sel = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D2", test_num);
            D0 = 8'hAA;
            D1 = 8'hBB;
            D2 = 8'hCC;
            D3 = 8'hDD;
            sel = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D3", test_num);
            D0 = 8'hAA;
            D1 = 8'hBB;
            D2 = 8'hCC;
            D3 = 8'hDD;
            sel = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D0 with all zeros", test_num);
            D0 = 8'h00;
            D1 = 8'hFF;
            D2 = 8'h55;
            D3 = 8'hAA;
            sel = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D1 with all ones", test_num);
            D0 = 8'h00;
            D1 = 8'hFF;
            D2 = 8'h55;
            D3 = 8'hAA;
            sel = 2'b01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D2 with pattern 01010101", test_num);
            D0 = 8'h00;
            D1 = 8'hFF;
            D2 = 8'h55;
            D3 = 8'hAA;
            sel = 2'b10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select D3 with pattern 10101010", test_num);
            D0 = 8'h00;
            D1 = 8'hFF;
            D2 = 8'h55;
            D3 = 8'hAA;
            sel = 2'b11;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
