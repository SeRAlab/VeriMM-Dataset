`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg WE;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .EN(EN),
        .WE(WE),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write 4'hA and Read back", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'hA;
            #10;

            WE = 0;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Check High-Z when EN=0", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'h5;
            #10;

            EN = 0; WE = 0;
            #10;
            #1;

            check_outputs(4'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify data persistence after disabling/enabling EN", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'hC;
            #10;

            EN = 0; WE = 0;
            #10;

            EN = 1;
            #10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify no write occurs when WE=0", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'h7;
            #10;

            WE = 0; data_in = 4'hF;
            #10;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify no write occurs when EN=0 and WE=1", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'h3;
            #10;

            EN = 0; WE = 1; data_in = 4'hE;
            #10;

            EN = 1; WE = 0;
            #10;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overwrite existing data", test_num);

            EN = 0; WE = 0; data_in = 4'h0;
            #10;

            EN = 1; WE = 1; data_in = 4'h1;
            #10;

            data_in = 4'h9;
            #10;

            WE = 0;
            #10;
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
