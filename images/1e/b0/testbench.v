`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg erase_en;
    reg write_en;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .clk(clk),
        .data_in(data_in),
        .erase_en(erase_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            erase_en = 1;
            write_en = 0;
            data_in = 0;
            @(negedge clk);
            erase_en = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Erase", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write 1", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 1;
            @(negedge clk);
            write_en = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write 0 after Write 1", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            data_in = 1;
            @(negedge clk);

            data_in = 0;
            @(negedge clk);
            write_en = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Erase after Write 1", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            data_in = 1;
            @(negedge clk);
            write_en = 0;


            @(negedge clk);
            erase_en = 1;
            @(negedge clk);
            erase_en = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 0;
            data_in = 1;
            @(negedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            data_in = 1;
            @(negedge clk);
            write_en = 0;
            data_in = 0;


            repeat(3) @(negedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Simultaneous Write and Erase", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            erase_en = 1;
            data_in = 1;
            @(negedge clk);
            write_en = 0;
            erase_en = 0;




            #1;





            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, data_in, erase_en, write_en, data_out);
    end

endmodule
