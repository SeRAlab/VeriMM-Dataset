`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A_i;
    reg [7:0] D_i;
    reg busclk_i;
    reg memclk_i;
    reg nRD_i;
    reg nWR_i;
    reg nreset_i;
    wire [7:0] D_o;
    wire [23:0] bus_A_o;
    wire [7:0] bus_D_o;
    wire [31:0] romflags_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .D_i(D_i),
        .busclk_i(busclk_i),
        .memclk_i(memclk_i),
        .nRD_i(nRD_i),
        .nWR_i(nWR_i),
        .nreset_i(nreset_i),
        .D_o(D_o),
        .bus_A_o(bus_A_o),
        .bus_D_o(bus_D_o),
        .romflags_o(romflags_o)
    );

    // Clock generation (10ns period)
    initial begin
        busclk_i = 0;
        forever #5 busclk_i = ~busclk_i;
    end

        task reset_dut;

        begin
            nreset_i = 0;
            A_i = 0;
            D_i = 0;
            nWR_i = 1;
            nRD_i = 1;
            repeat (5) @(posedge busclk_i);
            nreset_i = 1;
            repeat (2) @(posedge busclk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 24'h000000, 8'h00, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Configure bus_A_o", test_num);
            reset_dut();

            write_bus(4'h0, 8'h12);
            write_bus(4'h1, 8'h34);
            write_bus(4'h2, 8'h56);

            repeat (2) @(posedge busclk_i);
            #1;

            check_outputs(D_o, 24'h563412, bus_D_o, romflags_o);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Configure bus_D_o", test_num);
            reset_dut();

            write_bus(4'h3, 8'hA5);

            repeat (2) @(posedge busclk_i);
            #1;

            check_outputs(D_o, bus_A_o, 8'hA5, romflags_o);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Configure romflags_o", test_num);
            reset_dut();

            write_bus(4'h4, 8'hEF);
            write_bus(4'h5, 8'hBE);
            write_bus(4'h6, 8'hAD);
            write_bus(4'h7, 8'hDE);

            repeat (2) @(posedge busclk_i);
            #1;

            check_outputs(D_o, bus_A_o, bus_D_o, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Combined Write and Read-back", test_num);
            reset_dut();


            write_bus(4'h0, 8'hAA);
            write_bus(4'h3, 8'h55);
            write_bus(4'h7, 8'hFF);


            read_bus(4'h3);


            #1;



            check_outputs(8'h55, 24'h0000AA, 8'h55, 32'hFF000000);
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
        input [7:0] expected_D_o;
        input [23:0] expected_bus_A_o;
        input [7:0] expected_bus_D_o;
        input [31:0] expected_romflags_o;
        begin
            if (expected_D_o === (expected_D_o ^ D_o ^ expected_D_o) &&
                expected_bus_A_o === (expected_bus_A_o ^ bus_A_o ^ expected_bus_A_o) &&
                expected_bus_D_o === (expected_bus_D_o ^ bus_D_o ^ expected_bus_D_o) &&
                expected_romflags_o === (expected_romflags_o ^ romflags_o ^ expected_romflags_o)) begin
                $display("PASS");
                $display("  Outputs: D_o=%h, bus_A_o=%h, bus_D_o=%h, romflags_o=%h",
                         D_o, bus_A_o, bus_D_o, romflags_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_o=%h, bus_A_o=%h, bus_D_o=%h, romflags_o=%h",
                         expected_D_o, expected_bus_A_o, expected_bus_D_o, expected_romflags_o);
                $display("  Got:      D_o=%h, bus_A_o=%h, bus_D_o=%h, romflags_o=%h",
                         D_o, bus_A_o, bus_D_o, romflags_o);
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
        $dumpvars(0,A_i, D_i, busclk_i, memclk_i, nRD_i, nWR_i, nreset_i, D_o, bus_A_o, bus_D_o, romflags_o);
    end

endmodule
