`timescale 1ns/1ps

module memory_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Address 0");
            reset_dut();
            address = 8'h00;
            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Boundary Address 255");
            reset_dut();
            address = 8'hFF;
            data_in = 8'h5A;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Inactive Check");
            reset_dut();

            address = 8'h10;
            data_in = 8'h11;
            write_enable = 1;
            @(posedge clk);
            #1;

            data_in = 8'hEE;
            write_enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Address Switching and Data Persistence");
            reset_dut();

            address = 8'h20;
            data_in = 8'hCC;
            write_enable = 1;
            @(posedge clk);
            #1;

            address = 8'h21;
            data_in = 8'hDD;
            @(posedge clk);
            #1;

            write_enable = 0;
            address = 8'h20;
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting existing data");
            reset_dut();

            address = 8'h30;
            data_in = 8'h01;
            write_enable = 1;
            @(posedge clk);
            #1;

            data_in = 8'hFF;
            @(posedge clk);
            #1;
            write_enable = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Rapid Sequential Writes");
            reset_dut();
            write_enable = 1;
            address = 8'h80; data_in = 8'h01; @(posedge clk); #1;
            address = 8'h81; data_in = 8'h02; @(posedge clk); #1;
            address = 8'h82; data_in = 8'h03; @(posedge clk); #1;
            address = 8'h83; data_in = 8'h04; @(posedge clk); #1;
            write_enable = 0;
            address = 8'h82;
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory Testbench");
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
        $dumpvars(0,address, clk, data_in, write_enable, data_out);
    end

endmodule
