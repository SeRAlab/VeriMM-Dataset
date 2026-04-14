`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address;
    reg [8:0] byteenable;
    reg chipselect;
    reg clk;
    reg clken;
    reg reset;
    reg reset_req;
    reg write;
    reg [63:0] writedata;
    wire [63:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .byteenable(byteenable),
        .chipselect(chipselect),
        .clk(clk),
        .clken(clken),
        .reset(reset),
        .reset_req(reset_req),
        .write(write),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reset_req = 0;
            clken = 0;
            chipselect = 0;
            write = 0;
            address = 0;
            byteenable = 9'h1FF;
            writedata = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read back");
            reset_dut();


            @(posedge clk);
            clken = 1;
            chipselect = 1;
            write = 1;
            address = 9'h010;
            byteenable = 9'h1FF;
            writedata = 64'hFEDCBA9876543210;

            @(posedge clk);

            write = 0;
            address = 9'h010;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Chipselect check (Inhibit write)");
            reset_dut();


            @(posedge clk);
            clken = 1;
            chipselect = 0;
            write = 1;
            address = 9'h020;
            writedata = 64'hAAAA_BBBB_CCCC_DDDD;

            @(posedge clk);

            chipselect = 1;
            write = 0;
            address = 9'h020;

            @(posedge clk);
            #1;


            if (readdata != 64'hAAAA_BBBB_CCCC_DDDD) begin
                 $display("PASS: Write inhibited by chipselect=0");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Write occurred despite chipselect=0");
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Clock Enable (clken) check");
            reset_dut();


            @(posedge clk);
            clken = 1;
            chipselect = 1;
            write = 1;
            address = 9'h030;
            writedata = 64'h1111_2222_3333_4444;

            @(posedge clk);

            clken = 0;
            writedata = 64'hFFFF_FFFF_FFFF_FFFF;

            @(posedge clk);

            clken = 1;
            write = 0;
            address = 9'h030;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h1111_2222_3333_4444);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address check");
            reset_dut();


            @(posedge clk);
            clken = 1;
            chipselect = 1;
            write = 1;
            address = 9'd511;
            writedata = 64'h511_511_511_511_511;

            @(posedge clk);

            write = 0;
            address = 9'd511;

            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h511_511_511_511_511);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive writes");
            reset_dut();

            clken = 1;
            chipselect = 1;
            write = 1;


            address = 9'h001;
            writedata = 64'h0000000000000001;
            @(posedge clk);


            address = 9'h002;
            writedata = 64'h0000000000000002;
            @(posedge clk);


            write = 0;
            address = 9'h001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset request check");
            reset_dut();

            @(posedge clk);
            clken = 1;
            chipselect = 1;
            write = 1;
            address = 9'h0A0;
            writedata = 64'hABCDEFABCDEFABCD;

            @(posedge clk);
            reset_req = 1;
            write = 0;

            @(posedge clk);
            reset_req = 0;
            address = 9'h0A0;

            @(posedge clk);
            #1;




            #1;





            check_outputs(64'hABCDEFABCDEFABCD);
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
        input [63:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, byteenable, chipselect, clk, clken, reset, reset_req, write, writedata, readdata);
    end

endmodule
