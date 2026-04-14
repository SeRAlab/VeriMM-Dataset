`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg rw;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
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
            address = 4'h0;
            data_in = 16'h0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write and Read at Address 0", test_num);


            @(posedge rw);
            address = 4'h0;
            data_in = 16'hABCD;


            @(negedge rw);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read at Address 15", test_num);

            @(posedge rw);
            address = 4'hF;
            data_in = 16'h55AA;

            @(negedge rw);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify Address Isolation", test_num);


            @(posedge rw);
            address = 4'h2;
            data_in = 16'h1111;


            @(posedge rw);
            address = 4'h3;
            data_in = 16'h2222;


            @(negedge rw);
            address = 4'h2;
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Boundary Value 0xFFFF", test_num);

            @(posedge rw);
            address = 4'hA;
            data_in = 16'hFFFF;

            @(negedge rw);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Value 0x0000", test_num);

            @(posedge rw);
            address = 4'h5;
            data_in = 16'h0000;

            @(negedge rw);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Multiple Write Sequence", test_num);

            @(posedge rw);
            address = 4'h1; data_in = 16'hAAAA;
            @(posedge rw);
            address = 4'h2; data_in = 16'hBBBB;
            @(posedge rw);
            address = 4'h3; data_in = 16'hCCCC;


            @(negedge rw);
            address = 4'h3;
            #1;
            #1;

            check_outputs(16'hCCCC);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, data_in, rw, data_out);
    end

endmodule
