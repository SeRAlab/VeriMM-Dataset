`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
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
            @(posedge clk);
            write_en <= 0;
            read_en <= 0;
            data_in <= 8'h00;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'hA5;
            write_en <= 1;
            @(posedge clk);
            write_en <= 0;


            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Retention", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'h5A;
            write_en <= 1;
            @(posedge clk);


            write_en <= 0;
            data_in <= 8'hFF;
            repeat(3) @(posedge clk);


            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwriting Data", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'h11;
            write_en <= 1;
            @(posedge clk);


            data_in <= 8'h22;
            write_en <= 1;
            @(posedge clk);
            write_en <= 0;


            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Enable Sensitivity", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'hCC;
            write_en <= 1;
            @(posedge clk);
            write_en <= 0;


            read_en <= 0;
            @(posedge clk);


            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Protection", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'h77;
            write_en <= 0;
            @(posedge clk);


            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-Value Sequence", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'hDE;
            write_en <= 1;
            @(posedge clk);


            data_in <= 8'hAD;
            write_en <= 1;
            @(posedge clk);


            data_in <= 8'hBE;
            write_en <= 1;
            @(posedge clk);


            data_in <= 8'hEF;
            write_en <= 1;
            @(posedge clk);
            write_en <= 0;

            read_en <= 1;
            @(posedge clk);

            #1;


            check_outputs(8'hEF);
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
        input [7:0] expected_data_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, read_en, write_en, data_out);
    end

endmodule
