`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clock;
    reg [15:0] data;
    reg rden;
    reg wren;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data(data),
        .rden(rden),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 8'h00;
            data = 16'h0000;
            rden = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            address = 8'h10;
            data = 16'hABCD;
            wren = 1;
            rden = 0;
            @(posedge clock);
            #1;
            wren = 0;


            address = 8'h10;
            rden = 1;
            @(posedge clock);
            #1;
            rden = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Output Register Persistence", test_num);
            reset_dut();


            address = 8'h20;
            data = 16'h1234;
            wren = 1;
            @(posedge clock);
            #1;


            wren = 0;
            rden = 1;
            @(posedge clock);
            #1;



            rden = 0;
            address = 8'h55;
            data = 16'hFFFF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            address = 8'h30;
            data = 16'hAAAA;
            wren = 1;
            @(posedge clock);
            #1;


            data = 16'hBBBB;
            wren = 0;
            @(posedge clock);
            #1;


            rden = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 0xFF", test_num);
            reset_dut();

            address = 8'hFF;
            data = 16'h55AA;
            wren = 1;
            @(posedge clock);
            #1;
            wren = 0;
            rden = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 0x00", test_num);
            reset_dut();

            address = 8'h00;
            data = 16'hEE77;
            wren = 1;
            @(posedge clock);
            #1;
            wren = 0;
            rden = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hEE77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Read Verification", test_num);
            reset_dut();


            address = 8'h01; data = 16'h1111; wren = 1; @(posedge clock); #1;

            address = 8'h02; data = 16'h2222; wren = 1; @(posedge clock); #1;

            wren = 0;

            address = 8'h01; rden = 1; @(posedge clock); #1;

            address = 8'h02; rden = 1; @(posedge clock); #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data Check", test_num);
            reset_dut();

            address = 8'h40;
            data = 16'h1111;
            wren = 1;
            @(posedge clock); #1;

            data = 16'hFFFF;
            wren = 1;
            @(posedge clock); #1;

            wren = 0;
            rden = 1;
            @(posedge clock); #1;

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,address, clock, data, rden, wren, q);
    end

endmodule
