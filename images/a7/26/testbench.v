`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CCLK;
    reg debpb0;
    reg lcdaddr;
    reg lcdclear;
    reg lcddata;
    reg lcdhome;
    reg lcdreset;
    reg [255:0] strdata;
    wire addrlcd;
    wire clearlcd;
    wire datalcd;
    wire homelcd;
    wire initlcd;
    wire [7:0] lcddatin;
    wire resetlcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CCLK(CCLK),
        .debpb0(debpb0),
        .lcdaddr(lcdaddr),
        .lcdclear(lcdclear),
        .lcddata(lcddata),
        .lcdhome(lcdhome),
        .lcdreset(lcdreset),
        .strdata(strdata),
        .addrlcd(addrlcd),
        .clearlcd(clearlcd),
        .datalcd(datalcd),
        .homelcd(homelcd),
        .initlcd(initlcd),
        .lcddatin(lcddatin),
        .resetlcd(resetlcd)
    );

    // Clock generation (10ns period)
    initial begin
        CCLK = 0;
        forever #5 CCLK = ~CCLK;
    end

        task reset_dut;

        begin
            debpb0 = 1;
            lcdaddr = 0;
            lcdclear = 0;
            lcddata = 0;
            lcdhome = 0;
            lcdreset = 0;
            strdata = 0;
            repeat(5) @(posedge CCLK);
            debpb0 = 0;
            repeat(5) @(posedge CCLK);
        end
        endtask
    task handshake;

        input string signal_type;
        begin
            case (signal_type)
                "reset": begin
                    wait(resetlcd == 1);
                    repeat(2) @(posedge CCLK);
                    lcdreset = 1;
                    wait(resetlcd == 0);
                    repeat(2) @(posedge CCLK);
                    lcdreset = 0;
                end
                "clear": begin
                    wait(clearlcd == 1);
                    repeat(2) @(posedge CCLK);
                    lcdclear = 1;
                    wait(clearlcd == 0);
                    repeat(2) @(posedge CCLK);
                    lcdclear = 0;
                end
                "home": begin
                    wait(homelcd == 1);
                    repeat(2) @(posedge CCLK);
                    lcdhome = 1;
                    wait(homelcd == 0);
                    repeat(2) @(posedge CCLK);
                    lcdhome = 0;
                end
                "addr": begin
                    wait(addrlcd == 1);
                    repeat(2) @(posedge CCLK);
                    lcdaddr = 1;
                    wait(addrlcd == 0);
                    repeat(2) @(posedge CCLK);
                    lcdaddr = 0;
                end
                "data": begin
                    wait(datalcd == 1);
                    repeat(2) @(posedge CCLK);
                    lcddata = 1;
                    wait(datalcd == 0);
                    repeat(2) @(posedge CCLK);
                    lcddata = 0;
                end
            endcase
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Flow Sequence", test_num);
            reset_dut();

            strdata = 256'h48656C6C6F20576F726C64210000000000000000000000000000000000000000;
            debpb0 = 1;
            @(posedge CCLK);
            debpb0 = 0;


            handshake("reset");
            handshake("clear");
            handshake("home");
            handshake("addr");
            handshake("data");




            #1;





            check_outputs(0, 0, 0, 0, 1, 8'h48, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Full 32-byte data check", test_num);
            reset_dut();


            for(i=0; i<32; i=i+1) strdata[(31-i)*8 +: 8] = i + 1;

            debpb0 = 1;
            @(posedge CCLK);
            debpb0 = 0;

            handshake("reset");
            handshake("clear");
            handshake("home");


            for(i=0; i<32; i=i+1) begin
                handshake("addr");
                handshake("data");
            end


            #1;



            check_outputs(0, 0, 0, 0, 1, 8'h20, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Verify String Update", test_num);
            reset_dut();

            strdata = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            debpb0 = 1;
            @(posedge CCLK);
            debpb0 = 0;

            handshake("reset");
            handshake("clear");
            handshake("home");
            handshake("addr");
            handshake("data");


            #1;



            check_outputs(0, 0, 0, 0, 1, 8'hFF, 0);
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
        input expected_addrlcd;
        input expected_clearlcd;
        input expected_datalcd;
        input expected_homelcd;
        input expected_initlcd;
        input [7:0] expected_lcddatin;
        input expected_resetlcd;
        begin
            if (expected_addrlcd === (expected_addrlcd ^ addrlcd ^ expected_addrlcd) &&
                expected_clearlcd === (expected_clearlcd ^ clearlcd ^ expected_clearlcd) &&
                expected_datalcd === (expected_datalcd ^ datalcd ^ expected_datalcd) &&
                expected_homelcd === (expected_homelcd ^ homelcd ^ expected_homelcd) &&
                expected_initlcd === (expected_initlcd ^ initlcd ^ expected_initlcd) &&
                expected_lcddatin === (expected_lcddatin ^ lcddatin ^ expected_lcddatin) &&
                expected_resetlcd === (expected_resetlcd ^ resetlcd ^ expected_resetlcd)) begin
                $display("PASS");
                $display("  Outputs: addrlcd=%b, clearlcd=%b, datalcd=%b, homelcd=%b, initlcd=%b, lcddatin=%h, resetlcd=%b",
                         addrlcd, clearlcd, datalcd, homelcd, initlcd, lcddatin, resetlcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addrlcd=%b, clearlcd=%b, datalcd=%b, homelcd=%b, initlcd=%b, lcddatin=%h, resetlcd=%b",
                         expected_addrlcd, expected_clearlcd, expected_datalcd, expected_homelcd, expected_initlcd, expected_lcddatin, expected_resetlcd);
                $display("  Got:      addrlcd=%b, clearlcd=%b, datalcd=%b, homelcd=%b, initlcd=%b, lcddatin=%h, resetlcd=%b",
                         addrlcd, clearlcd, datalcd, homelcd, initlcd, lcddatin, resetlcd);
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
        $dumpvars(0,CCLK, debpb0, lcdaddr, lcdclear, lcddata, lcdhome, lcdreset, strdata, addrlcd, clearlcd, datalcd, homelcd, initlcd, lcddatin, resetlcd);
    end

endmodule
