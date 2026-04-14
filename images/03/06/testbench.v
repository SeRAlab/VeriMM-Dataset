`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Read (0xA)", test_num);

            write_enable = 0;
            data_in = 4'h0;
            #10;


            data_in = 4'hA;
            write_enable = 1;
            #10;


            write_enable = 0;
            data_in = 4'h0;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Data Persistence (Data change while WE=0)", test_num);

            data_in = 4'h5;
            write_enable = 1;
            #10;


            write_enable = 0;
            #10;
            data_in = 4'hF;
            #10;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write All Ones (0xF)", test_num);

            data_in = 4'h0;
            write_enable = 1;
            #10;


            data_in = 4'hF;
            write_enable = 1;
            #10;

            write_enable = 0;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write All Zeros (0x0)", test_num);

            data_in = 4'h7;
            write_enable = 1;
            #10;


            data_in = 4'h0;
            write_enable = 1;
            #10;

            write_enable = 0;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Write Toggle", test_num);

            data_in = 4'h3;
            write_enable = 1;
            #5;
            write_enable = 0;
            #5;

            data_in = 4'hC;
            write_enable = 1;
            #5;
            write_enable = 0;
            #10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
