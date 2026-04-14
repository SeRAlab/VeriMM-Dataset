`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg [3:0] data_in;
    reg rw;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .addr(addr),
        .data_in(data_in),
        .rw(rw),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        rw = 0;
        forever #5 rw = ~rw;
    end

        task reset_dut;

        begin
            addr = 2'b00;
            data_in = 4'h0;

            wait(rw == 0);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 4'hA to Address 00", test_num);
            reset_dut();


            @(posedge rw);
            addr = 2'b00;
            data_in = 4'hA;


            @(negedge rw);
            addr = 2'b00;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 4'h5 to Address 01", test_num);
            reset_dut();

            @(posedge rw);
            addr = 2'b01;
            data_in = 4'h5;

            @(negedge rw);
            addr = 2'b01;
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 4'hF to Address 10", test_num);
            reset_dut();

            @(posedge rw);
            addr = 2'b10;
            data_in = 4'hF;

            @(negedge rw);
            addr = 2'b10;
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 4'h3 to Address 11", test_num);
            reset_dut();

            @(posedge rw);
            addr = 2'b11;
            data_in = 4'h3;

            @(negedge rw);
            addr = 2'b11;
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Address 01 (4'h7 -> 4'hE)", test_num);
            reset_dut();


            @(posedge rw);
            addr = 2'b01;
            data_in = 4'h7;


            @(posedge rw);
            addr = 2'b01;
            data_in = 4'hE;


            @(negedge rw);
            addr = 2'b01;
            #2;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Persistence Check (Write Addr0, Write Addr1, Read Addr0)", test_num);
            reset_dut();


            @(posedge rw);
            addr = 2'b00;
            data_in = 4'hB;


            @(posedge rw);
            addr = 2'b01;
            data_in = 4'h2;


            @(negedge rw);
            addr = 2'b00;
            #2;
            #1;

            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,addr, data_in, rw, data_out);
    end

endmodule
