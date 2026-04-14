`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_en = 0;
        forever #5 read_en = ~read_en;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            write_en = 0;

            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read (Addr 0)", test_num);

            addr = 3'b000;
            data_in = 8'hAA;
            write_en = 1;
            #10;
            write_en = 0;

            #10;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Write and Read (Addr 7)", test_num);

            addr = 3'b111;
            data_in = 8'h55;
            write_en = 1;
            #10;
            write_en = 0;

            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Verify Write Enable (Disabled)", test_num);


            addr = 3'b010;
            data_in = 8'hAA;
            write_en = 1;
            #10;


            data_in = 8'hBB;
            write_en = 0;
            #10;


            #1;



            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Data Persistence", test_num);


            addr = 3'b001; data_in = 8'h11; write_en = 1; #10;

            addr = 3'b010; data_in = 8'h22; write_en = 1; #10;

            addr = 3'b011; data_in = 8'h33; write_en = 1; #10;

            write_en = 0;
            addr = 3'b001;
            #10;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Overwriting existing data", test_num);


            addr = 3'b100;
            data_in = 8'hCC;
            write_en = 1;
            #10;


            data_in = 8'hDD;
            #10;
            write_en = 0;

            #10;
            #1;

            check_outputs(8'hDD);
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
        $dumpvars(0,addr, data_in, read_en, write_en, data_out);
    end

endmodule
