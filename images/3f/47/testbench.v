`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
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
        .address(address),
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
        address = 3'b0;
        data_in = 8'b0;
        write_en = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read (Addr 0)", test_num);
        reset_dut();


        @(negedge read_en);
        address = 3'd0;
        data_in = 8'hA5;
        write_en = 1;
        @(negedge read_en);
        write_en = 0;


        @(posedge read_en);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Boundary Address Check (Addr 7)", test_num);
        reset_dut();


        @(negedge read_en);
        address = 3'd7;
        data_in = 8'h5A;
        write_en = 1;
        @(negedge read_en);
        write_en = 0;


        @(posedge read_en);
        #1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Overwrite Data Check", test_num);
        reset_dut();


        @(negedge read_en);
        address = 3'd2;
        data_in = 8'h11;
        write_en = 1;
        @(negedge read_en);


        data_in = 8'hFF;
        @(negedge read_en);
        write_en = 0;


        @(posedge read_en);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Multiple Address Data Retention", test_num);
        reset_dut();


        @(negedge read_en);
        address = 3'd1;
        data_in = 8'hAA;
        write_en = 1;
        @(negedge read_en);


        address = 3'd2;
        data_in = 8'hBB;
        @(negedge read_en);
        write_en = 0;


        address = 3'd1;
        @(posedge read_en);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Write Enable Verification", test_num);
        reset_dut();


        @(negedge read_en);
        address = 3'd4;
        data_in = 8'hCC;
        write_en = 1;
        @(negedge read_en);


        data_in = 8'hEE;
        write_en = 0;
        @(negedge read_en);


        @(posedge read_en);
        #1;
        #1;

        check_outputs(8'hCC);
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
        $dumpvars(0,address, data_in, read_en, write_en, data_out);
    end

endmodule
