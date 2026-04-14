`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] port0_rd_addr;
    reg port0_rd_en;
    reg [8:0] port1_rd_addr;
    reg port1_rd_en;
    reg [8:0] port2_rd_addr;
    reg port2_rd_en;
    reg [127:0] rd_data;
    wire [127:0] port_rd_data;
    wire [8:0] rd_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .port0_rd_addr(port0_rd_addr),
        .port0_rd_en(port0_rd_en),
        .port1_rd_addr(port1_rd_addr),
        .port1_rd_en(port1_rd_en),
        .port2_rd_addr(port2_rd_addr),
        .port2_rd_en(port2_rd_en),
        .rd_data(rd_data),
        .port_rd_data(port_rd_data),
        .rd_addr(rd_addr)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Port 0 Enabled", test_num);
        port0_rd_en = 1'b1; port0_rd_addr = 9'h0AA;
        port1_rd_en = 1'b0; port1_rd_addr = 9'h0BB;
        port2_rd_en = 1'b0; port2_rd_addr = 9'h0CC;
        rd_data = 128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD;
        #1;

        check_outputs(128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD, 9'h0AA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Port 1 Enabled", test_num);
        port0_rd_en = 1'b0; port0_rd_addr = 9'h0AA;
        port1_rd_en = 1'b1; port1_rd_addr = 9'h055;
        port2_rd_en = 1'b0; port2_rd_addr = 9'h0CC;
        rd_data = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
        #1;

        check_outputs(128'h1111_2222_3333_4444_5555_6666_7777_8888, 9'h055);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Port 2 Enabled", test_num);
        port0_rd_en = 1'b0; port0_rd_addr = 9'h0AA;
        port1_rd_en = 1'b0; port1_rd_addr = 9'h0BB;
        port2_rd_en = 1'b1; port2_rd_addr = 9'h1FF;
        rd_data = 128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888;
        #1;

        check_outputs(128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888, 9'h1FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Priority Check (Port 0 over Port 1)", test_num);
        port0_rd_en = 1'b1; port0_rd_addr = 9'h001;
        port1_rd_en = 1'b1; port1_rd_addr = 9'h002;
        port2_rd_en = 1'b0; port2_rd_addr = 9'h003;
        rd_data = 128'h0000_0000_0000_0000_0000_0000_0000_0010;
        #1;

        check_outputs(128'h0000_0000_0000_0000_0000_0000_0000_0010, 9'h001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Priority Check (Port 1 over Port 2)", test_num);
        port0_rd_en = 1'b0; port0_rd_addr = 9'h001;
        port1_rd_en = 1'b1; port1_rd_addr = 9'h002;
        port2_rd_en = 1'b1; port2_rd_addr = 9'h003;
        rd_data = 128'h0000_0000_0000_0000_0000_0000_0000_0020;
        #1;

        check_outputs(128'h0000_0000_0000_0000_0000_0000_0000_0020, 9'h002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Priority Check (All ports enabled)", test_num);
        port0_rd_en = 1'b1; port0_rd_addr = 9'h123;
        port1_rd_en = 1'b1; port1_rd_addr = 9'h045;
        port2_rd_en = 1'b1; port2_rd_addr = 9'h067;
        rd_data = 128'hFEED_FACE_CAFE_BEEF_0000_1111_2222_3333;
        #1;

        check_outputs(128'hFEED_FACE_CAFE_BEEF_0000_1111_2222_3333, 9'h123);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Priority Check (Port 0 over Port 2)", test_num);
        port0_rd_en = 1'b1; port0_rd_addr = 9'h077;
        port1_rd_en = 1'b0; port1_rd_addr = 9'h088;
        port2_rd_en = 1'b1; port2_rd_addr = 9'h099;
        rd_data = 128'h1234_5678_90AB_CDEF_1234_5678_90AB_CDEF;
        #1;

        check_outputs(128'h1234_5678_90AB_CDEF_1234_5678_90AB_CDEF, 9'h077);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: No Port Enabled", test_num);
        port0_rd_en = 1'b0; port0_rd_addr = 9'h1AA;
        port1_rd_en = 1'b0; port1_rd_addr = 9'h1BB;
        port2_rd_en = 1'b0; port2_rd_addr = 9'h1CC;
        rd_data = 128'h0;

        #1;


        check_outputs(128'h0, 9'h000);
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
        input [127:0] expected_port_rd_data;
        input [8:0] expected_rd_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_port_rd_data === (expected_port_rd_data ^ port_rd_data ^ expected_port_rd_data) &&
                expected_rd_addr === (expected_rd_addr ^ rd_addr ^ expected_rd_addr)) begin
                $display("PASS");
                $display("  Outputs: port_rd_data=%h, rd_addr=%h",
                         port_rd_data, rd_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_rd_data=%h, rd_addr=%h",
                         expected_port_rd_data, expected_rd_addr);
                $display("  Got:      port_rd_data=%h, rd_addr=%h",
                         port_rd_data, rd_addr);
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
