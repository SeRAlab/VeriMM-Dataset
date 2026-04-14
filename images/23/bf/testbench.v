`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg enable;
    reg write;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .data_in(data_in),
        .enable(enable),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            data_in = 8'h00;
            write = 0;
            @(posedge enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            write = 1;
            @(posedge enable);

            #1 write = 0;
            @(posedge enable);

            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            write = 1;
            @(posedge enable);

            #1 write = 0;
            @(posedge enable);

            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write-Disable (Write=0)", test_num);
            reset_dut();


            data_in = 8'hAA;
            write = 1;
            @(posedge enable);


            #1 data_in = 8'hEE;
            write = 0;
            @(posedge enable);

            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();

            data_in = 8'h12;
            write = 1;
            @(posedge enable);

            #1 write = 0;
            data_in = 8'h00;
            repeat(3) @(posedge enable);

            #1 #1;
 check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwriting Data", test_num);
            reset_dut();


            data_in = 8'hCC;
            write = 1;
            @(posedge enable);


            #1 data_in = 8'h33;
            write = 1;
            @(posedge enable);

            #1 write = 0;
            @(posedge enable);

            #1 #1;
 check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,data_in, enable, write, data_out);
    end

endmodule
