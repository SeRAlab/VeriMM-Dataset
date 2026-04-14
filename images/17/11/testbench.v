`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg [7:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_enable = 0;
        forever #5 read_enable = ~read_enable;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            write_enable = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read at Address 0", test_num);
            reset_dut();


            @(negedge read_enable);
            address = 3'd0;
            data_in = 8'hA5;
            write_enable = 1;
            @(negedge read_enable);
            write_enable = 0;


            @(posedge read_enable);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write/Read at Max Address 7", test_num);
            reset_dut();


            @(negedge read_enable);
            address = 3'd7;
            data_in = 8'h5A;
            write_enable = 1;
            @(negedge read_enable);
            write_enable = 0;


            @(posedge read_enable);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data at Address 3", test_num);
            reset_dut();


            @(negedge read_enable);
            address = 3'd3;
            data_in = 8'h11;
            write_enable = 1;
            @(negedge read_enable);


            data_in = 8'hFF;
            write_enable = 1;
            @(negedge read_enable);
            write_enable = 0;


            @(posedge read_enable);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable functionality", test_num);
            reset_dut();


            @(negedge read_enable);
            address = 3'd4;
            data_in = 8'hCC;
            write_enable = 1;
            @(negedge read_enable);


            data_in = 8'hDD;
            write_enable = 0;
            @(negedge read_enable);


            @(posedge read_enable);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence across multiple addresses", test_num);
            reset_dut();


            @(negedge read_enable);
            address = 3'd1;
            data_in = 8'hAA;
            write_enable = 1;
            @(negedge read_enable);


            address = 3'd2;
            data_in = 8'hBB;
            write_enable = 1;
            @(negedge read_enable);
            write_enable = 0;


            address = 3'd1;
            @(posedge read_enable);
            #1;
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
        $display("sram_cell Testbench");
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
        $dumpvars(0,address, data_in, read_enable, write_enable, data_out);
    end

endmodule
