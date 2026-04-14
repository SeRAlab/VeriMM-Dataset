`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg read;
    reg write_data;
    wire stored_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .enable(enable),
        .read(read),
        .write_data(write_data),
        .stored_data(stored_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            read = 0;
            write_data = 0;
            @(posedge clk);

            enable = 1;
            write_data = 0;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write 1 and Read 1", test_num);
            reset_dut();


            enable = 1;
            write_data = 1;
            @(posedge clk);
            enable = 0;


            read = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write 0 and Read 0", test_num);
            reset_dut();


            enable = 1;
            write_data = 0;
            @(posedge clk);
            enable = 0;


            read = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data hold when enable=0", test_num);
            reset_dut();


            enable = 1;
            write_data = 1;
            @(posedge clk);


            enable = 0;
            write_data = 0;
            @(posedge clk);


            read = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Output is low when read=0", test_num);
            reset_dut();


            enable = 1;
            write_data = 1;
            @(posedge clk);
            enable = 0;


            read = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Consecutive toggling writes", test_num);
            reset_dut();


            enable = 1;
            write_data = 1;
            @(posedge clk);


            write_data = 0;
            @(posedge clk);


            read = 1;
            #1;
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
        $display("flash_memory_cell Testbench");
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
        input expected_stored_data;
        begin
            if (expected_stored_data === (expected_stored_data ^ stored_data ^ expected_stored_data)) begin
                $display("PASS");
                $display("  Outputs: stored_data=%b",
                         stored_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_data=%b",
                         expected_stored_data);
                $display("  Got:      stored_data=%b",
                         stored_data);
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
        $dumpvars(0,clk, enable, read, write_data, stored_data);
    end

endmodule
