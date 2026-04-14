`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg erase;
    reg program;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .erase(erase),
        .program(program),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            erase = 1;
            program = 0;
            @(negedge clk);
            erase = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Programming cell to 1", test_num);
            reset_dut();


            program = 1;
            erase = 0;
            @(negedge clk);


            program = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Erasing cell (from 1 to 0)", test_num);
            reset_dut();


            program = 1;
            @(negedge clk);


            program = 0;
            erase = 1;
            @(negedge clk);

            erase = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (Erase and Program both high)", test_num);
            reset_dut();


            program = 1;
            erase = 1;
            @(negedge clk);

            program = 0;
            erase = 0;
            @(negedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data retention check (Value 1)", test_num);
            reset_dut();


            program = 1;
            @(negedge clk);


            program = 0;
            erase = 0;


            repeat(3) @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data retention check (Value 0)", test_num);
            reset_dut();


            program = 0;
            erase = 0;


            repeat(3) @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-programming cell (1 to 1)", test_num);
            reset_dut();

            program = 1;
            @(negedge clk);

            program = 1;
            @(negedge clk);

            program = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, erase, program, data_out);
    end

endmodule
