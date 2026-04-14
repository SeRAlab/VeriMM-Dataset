`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addra_i;
    reg [5:0] addrb_i;
    reg cena_i;
    reg cenb_i;
    reg clka;
    reg clkb;
    reg [31:0] dataa_i;
    reg [31:0] datab_i;
    reg oena_i;
    reg oenb_i;
    reg wena_i;
    reg wenb_i;
    wire [31:0] dataa_o;
    wire [31:0] datab_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra_i(addra_i),
        .addrb_i(addrb_i),
        .cena_i(cena_i),
        .cenb_i(cenb_i),
        .clka(clka),
        .clkb(clkb),
        .dataa_i(dataa_i),
        .datab_i(datab_i),
        .oena_i(oena_i),
        .oenb_i(oenb_i),
        .wena_i(wena_i),
        .wenb_i(wenb_i),
        .dataa_o(dataa_o),
        .datab_o(datab_o)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            cena_i = 0; oena_i = 0; wena_i = 0; addra_i = 0; dataa_i = 0;
            cenb_i = 0; oenb_i = 0; wenb_i = 0; addrb_i = 0; datab_i = 0;
            repeat(2) @(posedge clka);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Port A Basic Write/Read", test_num);


            @(posedge clka);
            cena_i = 1; wena_i = 1; addra_i = 6'h00; dataa_i = 32'h5555_AAAA;
            @(posedge clka);

            wena_i = 0; oena_i = 1;
            @(posedge clka);
            #1;
            #1;

            check_outputs(32'h5555_AAAA, datab_o);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Port B Boundary Write/Read (Addr 63)", test_num);


            @(posedge clkb);
            cenb_i = 1; wenb_i = 1; addrb_i = 6'd63; datab_i = 32'hDEAD_BEEF;
            @(posedge clkb);

            wenb_i = 0; oenb_i = 1;
            @(posedge clkb);
            #1;
            #1;

            check_outputs(dataa_o, 32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Port A and B Writes", test_num);

            @(posedge clka);

            cena_i = 1; wena_i = 1; addra_i = 6'd10; dataa_i = 32'h1111_1111;
            cenb_i = 1; wenb_i = 1; addrb_i = 6'd20; datab_i = 32'h2222_2222;
            @(posedge clka);

            wena_i = 0; oena_i = 1; addra_i = 6'd10;
            wenb_i = 0; oenb_i = 1; addrb_i = 6'd20;
            @(posedge clka);
            #1;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: 32-bit Data Integrity Check", test_num);


            @(posedge clka);
            cena_i = 1; wena_i = 1; addra_i = 6'd5; dataa_i = 32'hFFFF_FFFF;
            cenb_i = 1; wenb_i = 1; addrb_i = 6'd6; datab_i = 32'h0000_0000;
            @(posedge clka);

            wena_i = 0; oena_i = 1; addra_i = 6'd6;
            wenb_i = 0; oenb_i = 1; addrb_i = 6'd5;
            @(posedge clka);
            #1;
            #1;

            check_outputs(32'h0000_0000, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Port A Write followed by Port B Read same address", test_num);


            @(posedge clka);
            cena_i = 1; wena_i = 1; addra_i = 6'h15; dataa_i = 32'hABCD_1234;
            @(posedge clka);
            cena_i = 0; wena_i = 0;


            @(posedge clkb);
            cenb_i = 1; wenb_i = 0; oenb_i = 1; addrb_i = 6'h15;
            @(posedge clkb);
            #1;
            #1;

            check_outputs(dataa_o, 32'hABCD_1234);
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
        input [31:0] expected_dataa_o;
        input [31:0] expected_datab_o;
        begin
            if (expected_dataa_o === (expected_dataa_o ^ dataa_o ^ expected_dataa_o) &&
                expected_datab_o === (expected_datab_o ^ datab_o ^ expected_datab_o)) begin
                $display("PASS");
                $display("  Outputs: dataa_o=%h, datab_o=%h",
                         dataa_o, datab_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataa_o=%h, datab_o=%h",
                         expected_dataa_o, expected_datab_o);
                $display("  Got:      dataa_o=%h, datab_o=%h",
                         dataa_o, datab_o);
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
        $dumpvars(0,addra_i, addrb_i, cena_i, cenb_i, clka, clkb, dataa_i, datab_i, oena_i, oenb_i, wena_i, wenb_i, dataa_o, datab_o);
    end

endmodule
