`timescale 1ns/1ps

module control_register_block_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ctrl;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    control_register_block dut (
        .ctrl(ctrl),
        .out(out)
    );

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            ctrl = 4'b0010;
            #20;
            ctrl = 4'b0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load value 2'b10 into registers", test_num);
            reset_dut();


            ctrl = 4'b1000;
            #10;

            ctrl[0] = 1'b1;
            #10;
            ctrl[0] = 1'b0;
            #10;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load value 2'b01 into registers", test_num);
            reset_dut();


            ctrl = 4'b0100;
            #10;

            ctrl[0] = 1'b1;
            #10;
            ctrl[0] = 1'b0;
            #10;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load value 2'b11 (All High)", test_num);
            reset_dut();


            ctrl = 4'b1100;
            #10;

            ctrl[0] = 1'b1;
            #10;
            ctrl[0] = 1'b0;
            #10;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence (No Load)", test_num);
            reset_dut();


            ctrl = 4'b1101;
            #10;
            ctrl[0] = 1'b0;
            #10;



            ctrl = 4'b0000;
            #20;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous/Synchronous Reset during operation", test_num);
            reset_dut();


            ctrl = 4'b1101;
            #10;
            ctrl[0] = 1'b0;
            #10;


            ctrl[1] = 1'b1;
            #10;
            ctrl[1] = 1'b0;
            #10;

            #1;


            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("control_register_block Testbench");
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
        input [1:0] expected_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ctrl, out);
    end

endmodule
