`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addra;
    reg [4:0] addrb;
    reg [4:0] addrc;
    reg clock;
    reg [31:0] datac;
    reg enc;
    reg reset;
    wire [31:0] dataa;
    wire [31:0] datab;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .addrb(addrb),
        .addrc(addrc),
        .clock(clock),
        .datac(datac),
        .enc(enc),
        .reset(reset),
        .dataa(dataa),
        .datab(datab)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enc = 0;
            addra = 0;
            addrb = 0;
            addrc = 0;
            datac = 0;
            #2;
            reset = 0;
            #10;
            reset = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();

            @(negedge clock);
            addra = 5'd5;
            addrb = 5'd31;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Register Write/Read");
            reset_dut();


            @(negedge clock);
            enc = 1;
            addrc = 5'd10;
            datac = 32'hDEADBEEF;

            @(posedge clock);
            #1;
            enc = 0;


            @(negedge clock);
            addra = 5'd10;
            addrb = 5'd0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Dual Port Read");
            reset_dut();


            @(negedge clock);
            enc = 1;
            addrc = 5'd1;
            datac = 32'h11111111;
            @(posedge clock);


            @(negedge clock);
            addrc = 5'd2;
            datac = 32'h22222222;
            @(posedge clock);
            #1;
            enc = 0;


            @(negedge clock);
            addra = 5'd1;
            addrb = 5'd2;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write Enable (enc) logic check");
            reset_dut();


            @(negedge clock);
            enc = 0;
            addrc = 5'd15;
            datac = 32'hFFFFFFFF;

            @(posedge clock);
            #1;


            @(negedge clock);
            addra = 5'd15;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Register 0 Write/Read");
            reset_dut();

            @(negedge clock);
            enc = 1;
            addrc = 5'd0;
            datac = 32'hCAFEFACE;

            @(posedge clock);
            #1;
            enc = 0;

            @(negedge clock);
            addra = 5'd0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hCAFEFACE, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Register 31 Write/Read");
            reset_dut();

            @(negedge clock);
            enc = 1;
            addrc = 5'd31;
            datac = 32'h55AA55AA;

            @(posedge clock);
            #1;
            enc = 0;

            @(negedge clock);
            addrb = 5'd31;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 32'h55AA55AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Overwriting Data Check");
            reset_dut();


            @(negedge clock);
            enc = 1;
            addrc = 5'd20;
            datac = 32'h12345678;
            @(posedge clock);


            @(negedge clock);
            datac = 32'h87654321;
            @(posedge clock);
            #1;
            enc = 0;

            @(negedge clock);
            addra = 5'd20;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h87654321, 32'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Simultaneous Write and Read setup");
            reset_dut();


            @(negedge clock);
            enc = 1;
            addrc = 5'd5;
            datac = 32'hAAAA0000;
            @(posedge clock);


            @(negedge clock);
            addra = 5'd5;
            addrc = 5'd6;
            datac = 32'h0000BBBB;
            enc = 1;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAAAA0000, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_dataa;
        input [31:0] expected_datab;
        begin
            if (expected_dataa === (expected_dataa ^ dataa ^ expected_dataa) &&
                expected_datab === (expected_datab ^ datab ^ expected_datab)) begin
                $display("PASS");
                $display("  Outputs: dataa=%h, datab=%h",
                         dataa, datab);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataa=%h, datab=%h",
                         expected_dataa, expected_datab);
                $display("  Got:      dataa=%h, datab=%h",
                         dataa, datab);
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
        $dumpvars(0,addra, addrb, addrc, clock, datac, enc, reset, dataa, datab);
    end

endmodule
