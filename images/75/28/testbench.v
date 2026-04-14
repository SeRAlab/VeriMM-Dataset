`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] io_input_PADDR;
    reg io_input_PENABLE;
    reg io_input_PSEL;
    reg [31:0] io_input_PWDATA;
    reg io_input_PWRITE;
    reg [31:0] io_output_PRDATA;
    reg io_output_PREADY;
    reg io_output_PSLVERROR;
    wire [31:0] io_input_PRDATA;
    wire io_input_PREADY;
    wire io_input_PSLVERROR;
    wire [19:0] io_output_PADDR;
    wire io_output_PENABLE;
    wire [2:0] io_output_PSEL;
    wire [31:0] io_output_PWDATA;
    wire io_output_PWRITE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_input_PADDR(io_input_PADDR),
        .io_input_PENABLE(io_input_PENABLE),
        .io_input_PSEL(io_input_PSEL),
        .io_input_PWDATA(io_input_PWDATA),
        .io_input_PWRITE(io_input_PWRITE),
        .io_output_PRDATA(io_output_PRDATA),
        .io_output_PREADY(io_output_PREADY),
        .io_output_PSLVERROR(io_output_PSLVERROR),
        .io_input_PRDATA(io_input_PRDATA),
        .io_input_PREADY(io_input_PREADY),
        .io_input_PSLVERROR(io_input_PSLVERROR),
        .io_output_PADDR(io_output_PADDR),
        .io_output_PENABLE(io_output_PENABLE),
        .io_output_PSEL(io_output_PSEL),
        .io_output_PWDATA(io_output_PWDATA),
        .io_output_PWRITE(io_output_PWRITE)
    );
    task testcase001;

    begin
        test_num = 1;

        io_input_PADDR = 20'h00000;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b0;
        io_input_PWRITE = 1'b1;
        io_input_PWDATA = 32'hAAAA_BBBB;
        io_output_PRDATA = 32'h0;
        io_output_PREADY = 1'b0;
        io_output_PSLVERROR = 1'b0;



        #1;




        check_outputs(32'h0, 1'b0, 1'b0, 20'h00000, 1'b0, 3'b001, 32'hAAAA_BBBB, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        io_input_PADDR = 20'h40000;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b0;
        io_input_PWRITE = 1'b0;
        io_input_PWDATA = 32'h0;
        io_output_PRDATA = 32'h1234_5678;
        io_output_PREADY = 1'b1;
        io_output_PSLVERROR = 1'b0;

        #1;


        check_outputs(32'h1234_5678, 1'b1, 1'b0, 20'h40000, 1'b0, 3'b010, 32'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        io_input_PADDR = 20'h80000;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b1;
        io_input_PWRITE = 1'b1;
        io_input_PWDATA = 32'hDEAD_BEEF;
        io_output_PRDATA = 32'h0;
        io_output_PREADY = 1'b1;
        io_output_PSLVERROR = 1'b0;

        #1;


        check_outputs(32'h0, 1'b1, 1'b0, 20'h80000, 1'b1, 3'b100, 32'hDEAD_BEEF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        io_input_PADDR = 20'h00000;
        io_input_PSEL = 1'b0;
        io_input_PENABLE = 1'b0;
        io_input_PWRITE = 1'b0;
        io_input_PWDATA = 32'h0;
        io_output_PRDATA = 32'h0;
        io_output_PREADY = 1'b0;
        io_output_PSLVERROR = 1'b0;

        #1;


        check_outputs(32'h0, 1'b0, 1'b0, 20'h00000, 1'b0, 3'b000, 32'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        io_input_PADDR = 20'h41234;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b1;
        io_input_PWRITE = 1'b0;
        io_input_PWDATA = 32'h0;
        io_output_PRDATA = 32'hFFFF_FFFF;
        io_output_PREADY = 1'b1;
        io_output_PSLVERROR = 1'b1;

        #1;


        check_outputs(32'hFFFF_FFFF, 1'b1, 1'b1, 20'h41234, 1'b1, 3'b010, 32'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        io_input_PADDR = 20'h00ABC;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b1;
        io_input_PWRITE = 1'b1;
        io_input_PWDATA = 32'h55AA_55AA;
        io_output_PRDATA = 32'h0;
        io_output_PREADY = 1'b1;
        io_output_PSLVERROR = 1'b0;

        #1;


        check_outputs(32'h0, 1'b1, 1'b0, 20'h00ABC, 1'b1, 3'b001, 32'h55AA_55AA, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        io_input_PADDR = 20'h80004;
        io_input_PSEL = 1'b1;
        io_input_PENABLE = 1'b0;
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 20'h80004, 1'b0, 3'b100, 32'h0, 1'b0);

        #5;
        io_input_PENABLE = 1'b1;
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 20'h80004, 1'b1, 3'b100, 32'h0, 1'b0);
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
        input [31:0] expected_io_input_PRDATA;
        input expected_io_input_PREADY;
        input expected_io_input_PSLVERROR;
        input [19:0] expected_io_output_PADDR;
        input expected_io_output_PENABLE;
        input [2:0] expected_io_output_PSEL;
        input [31:0] expected_io_output_PWDATA;
        input expected_io_output_PWRITE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_input_PRDATA === (expected_io_input_PRDATA ^ io_input_PRDATA ^ expected_io_input_PRDATA) &&
                expected_io_input_PREADY === (expected_io_input_PREADY ^ io_input_PREADY ^ expected_io_input_PREADY) &&
                expected_io_input_PSLVERROR === (expected_io_input_PSLVERROR ^ io_input_PSLVERROR ^ expected_io_input_PSLVERROR) &&
                expected_io_output_PADDR === (expected_io_output_PADDR ^ io_output_PADDR ^ expected_io_output_PADDR) &&
                expected_io_output_PENABLE === (expected_io_output_PENABLE ^ io_output_PENABLE ^ expected_io_output_PENABLE) &&
                expected_io_output_PSEL === (expected_io_output_PSEL ^ io_output_PSEL ^ expected_io_output_PSEL) &&
                expected_io_output_PWDATA === (expected_io_output_PWDATA ^ io_output_PWDATA ^ expected_io_output_PWDATA) &&
                expected_io_output_PWRITE === (expected_io_output_PWRITE ^ io_output_PWRITE ^ expected_io_output_PWRITE)) begin
                $display("PASS");
                $display("  Outputs: io_input_PRDATA=%h, io_input_PREADY=%b, io_input_PSLVERROR=%b, io_output_PADDR=%h, io_output_PENABLE=%b, io_output_PSEL=%h, io_output_PWDATA=%h, io_output_PWRITE=%b",
                         io_input_PRDATA, io_input_PREADY, io_input_PSLVERROR, io_output_PADDR, io_output_PENABLE, io_output_PSEL, io_output_PWDATA, io_output_PWRITE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_input_PRDATA=%h, io_input_PREADY=%b, io_input_PSLVERROR=%b, io_output_PADDR=%h, io_output_PENABLE=%b, io_output_PSEL=%h, io_output_PWDATA=%h, io_output_PWRITE=%b",
                         expected_io_input_PRDATA, expected_io_input_PREADY, expected_io_input_PSLVERROR, expected_io_output_PADDR, expected_io_output_PENABLE, expected_io_output_PSEL, expected_io_output_PWDATA, expected_io_output_PWRITE);
                $display("  Got:      io_input_PRDATA=%h, io_input_PREADY=%b, io_input_PSLVERROR=%b, io_output_PADDR=%h, io_output_PENABLE=%b, io_output_PSEL=%h, io_output_PWDATA=%h, io_output_PWRITE=%b",
                         io_input_PRDATA, io_input_PREADY, io_input_PSLVERROR, io_output_PADDR, io_output_PENABLE, io_output_PSEL, io_output_PWDATA, io_output_PWRITE);
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

endmodule
