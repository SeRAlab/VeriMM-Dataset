`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [7:0] protocol;
    reg [31:0] src_ip;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .accept(accept)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Perfect Match", test_num);
            src_ip   = 32'hC0A8010A;
            dest_ip  = 32'h0A000005;
            protocol = 8'h06;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrong Source IP", test_num);
            src_ip   = 32'hC0A8010B;
            dest_ip  = 32'h0A000005;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrong Destination IP", test_num);
            src_ip   = 32'hC0A8010A;
            dest_ip  = 32'h0A0000FF;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrong Protocol (UDP instead of TCP)", test_num);
            src_ip   = 32'hC0A8010A;
            dest_ip  = 32'h0A000005;
            protocol = 8'h11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Fields Mismatched", test_num);
            src_ip   = 32'hFFFFFFFF;
            dest_ip  = 32'hEEEEEEEE;
            protocol = 8'hAA;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Case (All Zeros)", test_num);
            src_ip   = 32'h00000000;
            dest_ip  = 32'h00000000;
            protocol = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial IP Match (Bit flip)", test_num);
            src_ip   = 32'hC0A8010A;
            dest_ip  = 32'h0A000004;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Protocol Max Value", test_num);
            src_ip   = 32'hC0A8010A;
            dest_ip  = 32'h0A000005;
            protocol = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_accept;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accept === (expected_accept ^ accept ^ expected_accept)) begin
                $display("PASS");
                $display("  Outputs: accept=%b",
                         accept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept=%b",
                         expected_accept);
                $display("  Got:      accept=%b",
                         accept);
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
