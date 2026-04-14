`timescale 1ns/1ps

module wishbone2bus_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] bus_rdt;
    reg [1:0] wb_adr;
    reg wb_cyc;
    reg [31:0] wb_dat_w;
    reg [3:0] wb_sel;
    reg wb_stb;
    reg wb_we;
    wire [1:0] bus_adr;
    wire bus_ren;
    wire [31:0] bus_wdt;
    wire bus_wen;
    wire wb_ack;
    wire [31:0] wb_dat_r;
    wire wb_err;
    wire wb_rty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wishbone2bus dut (
        .bus_rdt(bus_rdt),
        .wb_adr(wb_adr),
        .wb_cyc(wb_cyc),
        .wb_dat_w(wb_dat_w),
        .wb_sel(wb_sel),
        .wb_stb(wb_stb),
        .wb_we(wb_we),
        .bus_adr(bus_adr),
        .bus_ren(bus_ren),
        .bus_wdt(bus_wdt),
        .bus_wen(bus_wen),
        .wb_ack(wb_ack),
        .wb_dat_r(wb_dat_r),
        .wb_err(wb_err),
        .wb_rty(wb_rty)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Idle State (No Cycle)", test_num);
            wb_cyc = 0;
            wb_stb = 0;
            wb_we  = 0;
            wb_adr = 2'b00;
            wb_dat_w = 32'h0;
            wb_sel = 4'h0;
            bus_rdt = 32'h0;


            #1;



            check_outputs(2'b00, 1'b0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Write Transaction", test_num);
            wb_cyc = 1;
            wb_stb = 1;
            wb_we  = 1;
            wb_adr = 2'b10;
            wb_dat_w = 32'hDEADBEEF;
            wb_sel = 4'hF;
            bus_rdt = 32'h0;


            #1;



            check_outputs(2'b10, 1'b0, 32'hDEADBEEF, 1'b1, 1'b1, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Read Transaction", test_num);
            wb_cyc = 1;
            wb_stb = 1;
            wb_we  = 0;
            wb_adr = 2'b01;
            wb_dat_w = 32'h0;
            wb_sel = 4'hF;
            bus_rdt = 32'hCAFEBABE;


            #1;



            check_outputs(2'b01, 1'b1, 32'h0, 1'b0, 1'b1, 32'hCAFEBABE, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Cycle Active but Strobe Low", test_num);
            wb_cyc = 1;
            wb_stb = 0;
            wb_we  = 1;
            wb_adr = 2'b11;
            wb_dat_w = 32'hAAAA5555;
            wb_sel = 4'hF;
            bus_rdt = 32'h0;


            #1;



            check_outputs(2'b11, 1'b0, 32'hAAAA5555, 1'b0, 1'b0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Strobe Active but Cycle Low", test_num);
            wb_cyc = 0;
            wb_stb = 1;
            wb_we  = 0;
            wb_adr = 2'b00;
            wb_dat_w = 32'h0;
            wb_sel = 4'hF;
            bus_rdt = 32'h12345678;


            #1;



            check_outputs(2'b00, 1'b0, 32'h0, 1'b0, 1'b0, 32'h12345678, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Mapping Check", test_num);
            wb_cyc = 1;
            wb_stb = 1;
            wb_we  = 1;
            wb_adr = 2'b11;
            wb_dat_w = 32'h13579BDF;
            wb_sel = 4'hF;
            bus_rdt = 32'h0;


            #1;



            check_outputs(2'b11, 1'b0, 32'h13579BDF, 1'b1, 1'b1, 32'h0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wishbone2bus Testbench");
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
        input [1:0] expected_bus_adr;
        input expected_bus_ren;
        input [31:0] expected_bus_wdt;
        input expected_bus_wen;
        input expected_wb_ack;
        input [31:0] expected_wb_dat_r;
        input expected_wb_err;
        input expected_wb_rty;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_adr === (expected_bus_adr ^ bus_adr ^ expected_bus_adr) &&
                expected_bus_ren === (expected_bus_ren ^ bus_ren ^ expected_bus_ren) &&
                expected_bus_wdt === (expected_bus_wdt ^ bus_wdt ^ expected_bus_wdt) &&
                expected_bus_wen === (expected_bus_wen ^ bus_wen ^ expected_bus_wen) &&
                expected_wb_ack === (expected_wb_ack ^ wb_ack ^ expected_wb_ack) &&
                expected_wb_dat_r === (expected_wb_dat_r ^ wb_dat_r ^ expected_wb_dat_r) &&
                expected_wb_err === (expected_wb_err ^ wb_err ^ expected_wb_err) &&
                expected_wb_rty === (expected_wb_rty ^ wb_rty ^ expected_wb_rty)) begin
                $display("PASS");
                $display("  Outputs: bus_adr=%h, bus_ren=%b, bus_wdt=%h, bus_wen=%b, wb_ack=%b, wb_dat_r=%h, wb_err=%b, wb_rty=%b",
                         bus_adr, bus_ren, bus_wdt, bus_wen, wb_ack, wb_dat_r, wb_err, wb_rty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_adr=%h, bus_ren=%b, bus_wdt=%h, bus_wen=%b, wb_ack=%b, wb_dat_r=%h, wb_err=%b, wb_rty=%b",
                         expected_bus_adr, expected_bus_ren, expected_bus_wdt, expected_bus_wen, expected_wb_ack, expected_wb_dat_r, expected_wb_err, expected_wb_rty);
                $display("  Got:      bus_adr=%h, bus_ren=%b, bus_wdt=%h, bus_wen=%b, wb_ack=%b, wb_dat_r=%h, wb_err=%b, wb_rty=%b",
                         bus_adr, bus_ren, bus_wdt, bus_wen, wb_ack, wb_dat_r, wb_err, wb_rty);
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
